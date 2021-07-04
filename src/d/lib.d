module jsonminify.lib;

import std : ctRegex, replaceAll, join, appender, array, matchAll, matchFirst, RegexMatch;

const tokenizer = ctRegex!(`"|(/\*)|(\*/)|(//)|\n|\r|[|]`, "g");

const spaceOrBreakRegex = ctRegex!(`\s`);

const repeatingBackSlashRegex = ctRegex!(`(\\)*$`);

extern (C) string minify(string jsonString)
{
  auto in_string = false;
  auto in_multiline_comment = false;
  auto in_singleline_comment = false;
  auto new_str = appender!(string[]);
  size_t from = 0;
  auto rightContext = "";

  auto match = jsonString.matchAll(tokenizer);

  while (true)
  {
    if (match.empty())
    {
      break;
    }
    match.popFront();

    const matchFrontHit = match.front().hit();

    const leftContext = match.pre();
    rightContext = match.post();

    const lastInddex = jsonString.length - rightContext.length - 1;

    if (!in_multiline_comment && !in_singleline_comment)
    {
      auto leftContextSubstr = leftContext[from .. $];
      if (!in_string)
      {
        leftContextSubstr = leftContextSubstr.replaceAll(spaceOrBreakRegex, "");
      }
      new_str.put(leftContextSubstr);
    }
    from = lastInddex;

    if (matchFrontHit == "\"" && !in_multiline_comment && !in_singleline_comment)
    {
      const lcMatch = leftContext.matchAll(repeatingBackSlashRegex);
      if (!in_string || lcMatch.empty() || lcMatch.captures.length() % 2 == 0)
      {
        // start of string with ", or unescaped " character found to end string
        in_string = !in_string;
      }
      --from; // include " character in next catch
      rightContext = jsonString[from .. $];
    }
    else if (matchFrontHit == "/*" && !in_string && !in_multiline_comment && !in_singleline_comment)
    {
      in_multiline_comment = true;
    }
    else if (matchFrontHit == "*/" && !in_string && in_multiline_comment && !in_singleline_comment)
    {
      in_multiline_comment = false;
    }
    else if (matchFrontHit == "//" && !in_string && !in_multiline_comment && !in_singleline_comment)
    {
      in_singleline_comment = true;
    }
    else if ((matchFrontHit == "\n" || matchFrontHit == "\r") && !in_string
        && !in_multiline_comment && in_singleline_comment)
    {
      in_singleline_comment = false;
    }
    else if (!in_multiline_comment && !in_singleline_comment
        && matchFrontHit.matchFirst(spaceOrBreakRegex).empty())
    {
      new_str.put(matchFrontHit);
    }
  }
  new_str.put(rightContext);
  return new_str.array().join("");
}
