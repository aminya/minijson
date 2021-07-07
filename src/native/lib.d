module minijson.lib;

import std : ctRegex, replaceAll, join, array, matchAll, matchFirst, RegexMatch;
import automem : Vector;

const tokenizer = ctRegex!(`"|(/\*)|(\*/)|(//)|\n|\r|[|]`, "g");

const spaceOrBreakRegex = ctRegex!(`\s`);

const repeatingBackSlashRegex = ctRegex!(`(\\)*$`);

/**
  Minify the given JSON string

  Params:
    jsonString  = the json string you want to minify
    hasComments = a switch that indicates if the json string has comments. Pass `true` to support parsing comments. Default: `false`.

  Return:
    the minified json string
*/
string minifyString(string jsonString, bool hasComments = false) @trusted
{
  auto in_string = false;
  auto in_multiline_comment = false;
  auto in_singleline_comment = false;
  Vector!string new_str;
  size_t from = 0;
  auto rightContext = "";

  auto match = jsonString.matchAll(tokenizer);

  while (!match.empty())
  {
    const matchFrontHit = match.front().hit();

    const leftContext = match.pre();
    rightContext = match.post();

    const lastIndex = jsonString.length - rightContext.length;

    const noCommentOrNotInComment = !hasComments || (!in_multiline_comment && !in_singleline_comment);
    if (noCommentOrNotInComment)
    {
      auto leftContextSubstr = leftContext[from .. $];
      if (!in_string)
      {
        leftContextSubstr = leftContextSubstr.replaceAll(spaceOrBreakRegex, "");
      }
      new_str ~= leftContextSubstr;
    }
    from = lastIndex;

    if (noCommentOrNotInComment)
    {
      if (matchFrontHit == "\"")
      {
        if (!in_string || hasNoSlashOrEvenNumberOfSlashes(leftContext))
        {
          // start of string with ", or unescaped " character found to end string
          in_string = !in_string;
        }
        --from; // include " character in next catch
        rightContext = jsonString[from .. $];
      }
      else if (matchFrontHit.matchFirst(spaceOrBreakRegex).empty())
      {
        new_str ~= matchFrontHit;
      }
    }
    // comments
    if (hasComments && !in_string)
    {
      if (!in_multiline_comment && !in_singleline_comment)
      {
        if (matchFrontHit == "/*")
        {
          in_multiline_comment = true;
        }
        else if (matchFrontHit == "//")
        {
          in_singleline_comment = true;
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

    match.popFront();
  }
  new_str ~= rightContext;
  return new_str.array().join("");
}

bool hasNoSlashOrEvenNumberOfSlashes(string leftContext) @safe
{
  auto leftContextMatch = leftContext.matchFirst(repeatingBackSlashRegex);
  return leftContextMatch.empty() || (leftContextMatch.hit().length % 2 == 0);
}

/**
  Minify the given files in place. It minifies the files in parallel.

  Params:
    files = the paths to the files.
*/
void minifyFiles(string[] files)
{
  import std.parallelism : parallel;
  import std.file : readText, write;

  foreach (ref file; files.parallel())
  {
    const string jsonString = readText(file);
    const minifiedJsonString = minifyString(jsonString);
    write(file, minifiedJsonString);
  }
}
