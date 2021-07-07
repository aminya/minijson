module minijson.cli;

import minijson.lib : minifyFiles, minifyString;

import std.getopt : getopt, defaultGetoptPrinter, GetoptResult;

/** Print help */
void printHelp(GetoptResult optResult) @trusted
{
  return defaultGetoptPrinter(`minijson: minify json files with support for comments
    minijson --file file1.json --file file2.json
    minijson --file file1_with_comment.json --file file2_with_comment.json --comment

    minijson --string '{"some_json": "string_here"}'
    minijson --string '{"some_json": "string_here"} //comment' --comment

    More information at https://github.com/aminya/minijson
  `, optResult.options);
}

void main(string[] args) @trusted
{
  string[] files;
  string jsonString;
  bool hasComment = false;

  auto optResult = getopt(args, "file", "an array of files to minify", &files, "string",
      "a json string to minify", &jsonString, "comment", "a flag to support comments in json", &hasComment);

  if (optResult.helpWanted || (!files && !jsonString))
  {
    return printHelp(optResult);
  }

  // minify the given files
  if (files)
  {
    minifyFiles(files, hasComment);
  }

  // minify the given string and print to stdout
  if (jsonString)
  {
    import std : write;

    write(minifyString(jsonString, hasComment));
  }
}
