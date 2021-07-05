module minijson.libc;

import minijson.lib : minify;

extern (C):

/**
  Minify the given JSON string using C ABI.

  Params:
    jsonString  = the json string you want to minify
    hasComments = a switch that indicates if the json string has comments.
                  Passing `false` can result in higher performance. Default: `true`.

  Return:
    the minified json string
*/
auto minify(char* jsonCString, bool hasComments = true)
{
  import std : fromStringz, toStringz;

  const string jsonString = fromStringz(jsonCString).idup;
  const minifiedString = minify(jsonString, hasComments);

  return toStringz(minifiedString);
}
