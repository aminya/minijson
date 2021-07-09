module minijson.remove_spaces;

import despacer.libc.despacer_SSE4_1 : sse4_despace_branchless_u4;
import std : fromStringz, toStringz;

/** Removes spaces from the original string */
string remove_spaces(string str) nothrow
{
  char* cstr = cast(char*) toStringz(str);
  const length = str.length;
  const keepingPos = sse4_despace_branchless_u4(cstr, length);
  return str[0 .. keepingPos];
}
