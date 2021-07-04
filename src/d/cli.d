module jsonminify.cli;

import jsonminify.lib : minify;

import std.parallelism : parallel;
import std.getopt : getopt, defaultGetoptPrinter, GetoptResult;
import std.file : readText, write;

/** Print help */
void printHelp(GetoptResult optResult)
{
  return defaultGetoptPrinter("Usage: minify json files", optResult.options);
}

void main(string[] args)
{

  string[] files;

  auto optResult = getopt(args, "files", "the files to minify", &files);

  if (optResult.helpWanted || !files)
  {
    return printHelp(optResult);
  }

  foreach (ref file; files.parallel())
  {
    const string jsonString = readText(file);
    const minifiedJsonString = minify(jsonString);
    write(file, minifiedJsonString);
  }
}
