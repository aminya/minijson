module minijson.lib;

import std : ctRegex, matchAll, matchFirst;

import despacer.simd_check : supports_sse4_1, supports_avx2;

const tokenizerWithComment = ctRegex!(`"|(/\*)|(\*/)|(//)|\n|\r|\[|]`, "g");
const tokenizerNoComment = ctRegex!(`[\n\r"[]]`, "g");

/**
  Minify the given JSON string

  Params:
    jsonString  = the json string you want to minify
    hasComment = a boolean to support comments in json. Default: `false`.

  Return:
    the minified json string
*/
string minifyString(in string jsonString, in bool hasComment = false) @trusted
{
  auto in_string = false;
  auto in_multiline_comment = false;
  auto in_singleline_comment = false;
  string result;
  size_t from = 0;
  auto rightContext = "";

  const tokenizer = !hasComment ? tokenizerNoComment : tokenizerWithComment;

  auto match = jsonString.matchAll(tokenizer);

  while (!match.empty())
  {
    const matchFrontHit = match.front().hit();

    rightContext = match.post();

    // update from for the next iteration
    const prevFrom = from;
    from = jsonString.length - rightContext.length; // lastIndex

    const notInComment = (!in_multiline_comment && !in_singleline_comment);
    const noCommentOrNotInComment = !hasComment || notInComment;

    if (noCommentOrNotInComment)
    {
      auto leftContextSubstr = match.pre()[prevFrom .. $];
      const noLeftContext = leftContextSubstr.length == 0;
      if (!noLeftContext)
      {
        if (!in_string)
        {
          leftContextSubstr = remove_spaces(leftContextSubstr);
        }
        result ~= leftContextSubstr;
      }
      if (matchFrontHit == "\"")
      {
        if (!in_string || noLeftContext || hasNoSlashOrEvenNumberOfSlashes(leftContextSubstr))
        {
          // start of string with ", or unescaped " character found to end string
          in_string = !in_string;
        }
        --from; // include " character in next catch
        rightContext = jsonString[from .. $];
      }
    }
    // comments
    if (hasComment && !in_string)
    {
      if (notInComment)
      {
        if (matchFrontHit == "/*")
        {
          in_multiline_comment = true;
        }
        else if (matchFrontHit == "//")
        {
          in_singleline_comment = true;
        }
        else if (notSlashAndNoSpaceOrBreak(matchFrontHit))
        {
          result ~= matchFrontHit;
        }
      }
      else if (in_multiline_comment && !in_singleline_comment && matchFrontHit == "*/")
      {
        in_multiline_comment = false;
      }
      else if (!in_multiline_comment && in_singleline_comment && (matchFrontHit == "\n" || matchFrontHit == "\r"))
      {
        in_singleline_comment = false;
      }
    }
    else if (!hasComment && notSlashAndNoSpaceOrBreak(matchFrontHit))
    {
      result ~= matchFrontHit;
    }
    match.popFront();
  }
  result ~= rightContext;
  return result;
}

private bool hasNoSlashOrEvenNumberOfSlashes(in string leftContextSubstr) @safe @nogc
{
  size_t slashCount = 0;

  // NOTE leftContextSubstr.length is not 0 (checked outside of the function)
  size_t index = leftContextSubstr.length - 1;

  // loop over the string backwards and find `\`
  while (leftContextSubstr[index] == '\\')
  {
    slashCount += 1;

    index -= 1;
  }
  // no slash or even number of slashes
  return slashCount % 2 == 0;
}

private bool notSlashAndNoSpaceOrBreak(const ref string str) @safe
{
  return str != "\"" && hasNoSpace(str);
}

/** Removes spaces from the original string */
private string remove_spaces(string str) @trusted
{
  static if (supports_sse4_1())
  {
    import despacer.despacer : sse4_despace_branchless_u4;

    // this wrapper reduces the overall time by 15 compared to d_sse4_despace_branchless_u4 because of no dup and toStringz
    auto cstr = cast(char*) str;
    const length = str.length;
    return str[0 .. sse4_despace_branchless_u4(cstr, length)];
  }
  else
  {
    import std.regex : replaceAll;

    const spaceOrBreakRegex = ctRegex!(`\s`);
    return str.replaceAll(spaceOrBreakRegex, "");
  }
}

/** Check if the given string has space  */
private bool hasNoSpace(const ref string str) @trusted
{
  static if (supports_avx2())
  {
    import despacer.despacer : avx2_hasspace;

    // the algorithm never checks for zero termination so toStringz is not needed
    return !avx2_hasspace(cast(const char*) str, str.length);
  }
  else
  {
    import std.regex : matchFirst;

    const spaceOrBreakRegex = ctRegex!(`\s`);
    return str.matchFirst(spaceOrBreakRegex).empty();
  }
}

/**
  Minify the given JSON strings in parallel

  Params:
    jsonStrings  = the json strings you want to minify
    hasComment = a boolean to support comments in json. Default: `false`.

  Return:
    the minified json strings
*/
string[] minifyStrings(in string[] jsonStrings, in bool hasComment = false) @trusted
{
  import std.algorithm : map;
  import std.array : array;

  return jsonStrings.map!(jsonString => minifyString(jsonString, hasComment)).array();
}

/**
  Minify the given files in place. It minifies the files in parallel.

  Params:
    paths = the paths to the files. It could be glob patterns.
    hasComment = a boolean to support comments in json. Default: `false`.
*/
void minifyFiles(in string[] paths, in bool hasComment = false) @trusted
{
  import std.parallelism : parallel;
  import std.algorithm;
  import std.array;
  import std.file : dirEntries, SpanMode, readText, write, isFile, isDir, exists;
  import std.path : globMatch;
  import glob : glob;
  import std.stdio : writeln;

  // get the files from the given paths (resolve glob patterns)
  auto files = paths.map!((path) {
    if (path.exists)
    {
      if (path.isFile)
      {
        return [path];
      }
      else if (path.isDir)
      {
        return glob(path ~ "/**/*.json");
      }
      else
      {
        throw new Exception("The given path is not a file or a directory: " ~ path);
      }
    }
    else
    {
      return glob(path);
    }
  }).joiner().array();

  if (files.empty)
  {
    writeln("No files found.");
    return;
  }

  if (!confirmExtension(files))
  {
    return;
  }

  foreach (file; files.parallel())
  {
    write(file, minifyString(readText(file), hasComment));
  }
}

bool confirmExtension(string[] files) @trusted
{
  auto confirmExtension = false;
  import std.path : extension;

  foreach (file; files)
  {
    // if the file extension is not json, jsonc, or json5, confirm before minifying
    auto fileExtension = file.extension();
    if (fileExtension != ".json" && fileExtension != ".jsonc" && fileExtension != ".json5")
    {
      if (!confirmExtension)
      {
        import std.stdio : readln, writeln;

        writeln("The file ", file, " doesn't have a json extension. Do you want to minify it? (y/n)");
        auto input = readln();
        confirmExtension = input == "y";
        if (!confirmExtension)
        {
          return false;
        }
      }
    }
  }

  return true;
}
