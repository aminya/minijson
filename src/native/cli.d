module minijson.cli;

import minijson.lib : minifyFiles;

import std.getopt : getopt, defaultGetoptPrinter, GetoptResult;

/** Print help */
void printHelp(GetoptResult optResult) @trusted
{
  return defaultGetoptPrinter("Usage: minify json files.\nminijson --file file1.json --file file2.json", optResult
      .options);
}

void main(string[] args) @trusted
{
  string[] files;

  auto optResult = getopt(args, "file", "the json file to minify", &files);

  if (optResult.helpWanted || !files)
  {
    return printHelp(optResult);
  }

  minifyFiles(files);
}
