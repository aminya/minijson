module minijson.lib;

import std : ctRegex, replaceAll, join, array, matchAll, matchFirst, RegexMatch;

const tokenizerWithComment = ctRegex!(`"|(/\*)|(\*/)|(//)|\n|\r|\[|]`, "g");
const tokenizerNoComment = ctRegex!(`[\n\r"[]]`, "g");

const spaceOrBreakRegex = ctRegex!(`\s`);

const repeatingBackSlashRegex = ctRegex!(`(\\)*$`);

/**
  Minify the given JSON string

  Params:
    jsonString  = the json string you want to minify
    hasComment = a boolean to support comments in json. Default: `false`.

  Return:
    the minified json string
*/
string minifyString(string jsonString, bool hasComment = false) @trusted
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

      if (!in_string)
      {
        leftContextSubstr = leftContextSubstr.replaceAll(spaceOrBreakRegex, "");
      }
      result ~= leftContextSubstr;

      if (matchFrontHit == "\"")
      {
        if (!in_string || hasNoSlashOrEvenNumberOfSlashes(leftContextSubstr))
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

private bool hasNoSlashOrEvenNumberOfSlashes(string leftContext) @safe
{
  auto leftContextMatch = leftContext.matchFirst(repeatingBackSlashRegex);
  // if not matched the hit length will be 0 (== leftContextMatch.empty())
  return leftContextMatch.hit().length % 2 == 0;
}

private bool notSlashAndNoSpaceOrBreak(string matchFrontHit)
{
  return matchFrontHit != "\"" && matchFrontHit.matchFirst(spaceOrBreakRegex).empty();
}

/**
  Minify the given files in place. It minifies the files in parallel.

  Params:
    files = the paths to the files.
    hasComment = a boolean to support comments in json. Default: `false`.
*/
void minifyFiles(string[] files, bool hasComment = false)
{
  import std.parallelism : parallel;
  import std.file : readText, write;

  foreach (ref file; files.parallel())
  {
    const string jsonString = readText(file);
    const minifiedJsonString = minifyString(jsonString, hasComment);
    write(file, minifiedJsonString);
  }
}
