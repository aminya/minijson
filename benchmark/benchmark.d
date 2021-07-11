module minijson.benchmark;

import minijson.lib : minifyFiles, minifyString;

import std : dirEntries, array, SpanMode, writeln, map, readText, parallel, iota;
import std.datetime.stopwatch : benchmark, StopWatch, AutoStart, Duration;

void main()
{
  const string[] files = dirEntries("./test/fixtures/standard", SpanMode.shallow).map!(entry => entry.name).array();

  string[] filesContent;
  foreach (file; files.parallel())
  {
    filesContent ~= readText(file);
  }

  Duration result;
  auto sw = StopWatch(AutoStart.yes);

  writeln("Benchmark minifyFiles");
  sw.reset();

  minifyFiles(files);

  result = sw.peek();
  writeln(result);

  writeln("Benchmark minifyString");
  const repeat = 20;
  string tmp;

  sw.reset();
  foreach (_; iota(repeat))
  {
    foreach (fileContent; filesContent)
    {
      tmp = minifyString(fileContent);
    }
  }
  result = sw.peek();

  writeln(result / repeat);
}
