module minijson.benchmark;

import minijson.lib: minifyFiles;

import std.datetime.stopwatch: benchmark;
import std: dirEntries, array, SpanMode, writeln, map;

void main() {
  const string[] files = dirEntries("./test/fixtures/standard", SpanMode.shallow).map!(entry => entry.name).array();

  void minifyFilesCaller() {
    minifyFiles(files);
  }
  auto result = benchmark!(minifyFilesCaller)(1);

  writeln(result);
}
