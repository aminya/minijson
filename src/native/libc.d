module minijson.libc;

import minijson.lib : minifyString;

/**
  Minify the given JSON string using C ABI.

  Params:
    jsonString  = the json string you want to minify
    hasComment = a boolean to support comments in json. Default: `true`.

  Return:
    the minified json string
*/
extern (C) auto c_minifyString(char* jsonCString, bool hasComment = true)
{
  import std : fromStringz, toStringz;

  const string jsonString = fromStringz(jsonCString).idup;
  const minifiedString = minifyString(jsonString, hasComment);

  return toStringz(minifiedString);
}
