module minijson.lib;

import std : ctRegex, matchAll, matchFirst;
import bc.string: String;

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
  String result;
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
      if (!noLeftContext) {
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
  return cast (string) result;
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

private bool notSlashAndNoSpaceOrBreak(const ref string matchFrontHit) @safe
{
  return matchFrontHit != "\"" && hasNoSpace(matchFrontHit);
}

/** Removes spaces from the original string */
private string remove_spaces(string str) @trusted nothrow
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
    const spaceOrBreakRegex = ctRegex!(`\s`);
    leftContextSubstr.replaceAll(spaceOrBreakRegex, "");
  }
}

/** Check if the given string has space  */
private bool hasNoSpace(const ref string matchFrontHit) @trusted
{
  static if (supports_avx2())
  {
    import despacer.despacer : avx2_hasspace;

    // the algorithm never checks for zero termination so toStringz is not needed
    return !avx2_hasspace(cast(const char*) matchFrontHit, matchFrontHit.length);
  }
  else
  {
    const spaceOrBreakRegex = ctRegex!(`\s`);
    return matchFrontHit.matchFirst(spaceOrBreakRegex).empty();
  }
}

/**
  Minify the given files in place. It minifies the files in parallel.

  Params:
    files = the paths to the files.
    hasComment = a boolean to support comments in json. Default: `false`.
*/
void minifyFiles(in string[] files, in bool hasComment = false)
{
  import std.parallelism : parallel;
  import std.file : readText, write;

  foreach (file; files.parallel())
  {
    write(file, minifyString(readText(file), hasComment));
  }
}
