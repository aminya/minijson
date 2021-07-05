module minijson.libc;

import minijson.lib : minify;

extern (C):

/** A C wrapper around minify */
auto minify(char* jsonCString)
{
  import std : fromStringz, toStringz;

  const string jsonString = fromStringz(jsonCString).idup;
  const minifiedString = minify(jsonString);

  return toStringz(minifiedString);
}
