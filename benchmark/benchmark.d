module minijson.benchmark;

import minijson.lib : minifyFiles, minifyString;

import std : dirEntries, array, SpanMode, writeln, map, readText, parallel, iota, getopt;
import std.datetime.stopwatch : benchmark, StopWatch, AutoStart, Duration;

void main(string[] args)
{
  bool benchmarkMinifyFiles = false;
  bool benchmarkMinifyString = true;

  getopt(args, "benchmark-minifyFiles", &benchmarkMinifyFiles, "benchmark-minifyString", &benchmarkMinifyString);

  const string[] files = dirEntries("./test/fixtures/standard", SpanMode.shallow).map!(entry => entry.name).array();

  string[] filesContent;
  foreach (file; files.parallel())
  {
    filesContent ~= readText(file);
  }

  Duration result;
  auto sw = StopWatch(AutoStart.yes);

  if (benchmarkMinifyFiles)
  {
    writeln("Benchmark minifyFiles");
    sw.reset();

    minifyFiles(files);

    result = sw.peek();
    writeln(result);
  }

  if (benchmarkMinifyString)
  {
    writeln("Benchmark minifyString");
    const repeat = 120;
    auto repeater = iota(repeat);
    string tmp;

    sw.reset();
    foreach (_; repeater)
    {
      foreach (fileContent; filesContent)
      {
        tmp = minifyString(fileContent);
      }
    }
    result = sw.peek();

    writeln(result / repeat);
  }
}
