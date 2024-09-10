module minijson.cli;

import minijson.lib : minifyFiles, minifyStrings;
import argparse;

@(Command("minijson").Description(`minijson: minify json files with support for comments

    # Minify the specified files
    minijson ./dist/**/*.json ./build/a.json

    # Minify the specified files (supports comments)
    minijson --comment file1_with_comment.json file2_with_comment.json

    # Minify the specified json string
    minijson --str '{"some_json": "string_here"}'

    # Minify the specified json string (supports comments)
    minijson --comment --str '{"some_json": "string_here"} //comment'

    More information at https://github.com/aminya/minijson
  `))
struct Options
{
  bool comment = false;
  string[] str;
  // (Deprecated) A list of files to minify (for backwards compatiblitity with getopt)
  string[] file;
}

int actualMain(Options opts, string[] files) @trusted
{
  try
  {
    // minify the given files
    if (files.length > 0 || opts.file.length > 0)
    {
      minifyFiles(files ~ opts.file, opts.comment);
    }

    // minify the given string and print to stdout
    if (opts.str)
    {
      import std.algorithm : each;
      import std.stdio : writeln;

      minifyStrings(opts.str, opts.comment).each!writeln;

    }
  }
  catch (Exception e)
  {
    import std.stdio : stderr;

    stderr.writeln("Error: ", e.msg);
    return 1;
  }

  return 0;
}

mixin CLI!Options.main!((opts, unparsed) { return actualMain(opts, unparsed); });
