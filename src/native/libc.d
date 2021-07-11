module minijson.libc;

import minijson.lib : minifyString;

/**
  Minify the given JSON string using C ABI.

  Params:
    jsonString  = the json string you want to minify
    hasComment = a boolean to support comments in json. Default: `false`.

  Return:
    the minified json string
*/
extern (C) auto c_minifyString(in char* jsonCString, in bool hasComment = false)
{
  import std : fromStringz, toStringz;

  const string jsonString = fromStringz(jsonCString).idup;
  const minifiedString = minifyString(jsonString, hasComment);

  return toStringz(minifiedString);
}
