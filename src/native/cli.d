module minijson.cli;

import minijson.lib : minifyFiles, minifyString;

import std.getopt : getopt, defaultGetoptPrinter, GetoptResult;

/** Print help */
void printHelp(GetoptResult optResult) @trusted
{
  return defaultGetoptPrinter(`Usage: minify json
    minijson --file file1.json --file file2.json
    minijson --string '{"some_json": "string_here"}'
  `, optResult.options);
}

void main(string[] args) @trusted
{
  string[] files;
  string jsonString;

  auto optResult = getopt(args, "file", "an array of files to minify", &files, "string",
      "a json string to minify", &jsonString);

  if (optResult.helpWanted || (!files && !jsonString))
  {
    return printHelp(optResult);
  }

  // minify the given files
  if (files)
  {
    minifyFiles(files);
  }

  // minify the given string and print to stdout
  if (jsonString)
  {
    import std : write;

    write(minifyString(jsonString));
  }
}
