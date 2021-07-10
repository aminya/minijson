module minijson.remove_spaces;

import despacer.libc.despacer_SSE4_1 : sse4_despace_branchless_u4;
import std : fromStringz, toStringz;

/** Removes spaces from the original string */
string remove_spaces(string str) nothrow
{
  auto cstr = cast(char*) toStringz(str.dup);
  const length = str.length;
  const keepingPos = sse4_despace_branchless_u4(cstr, length);
  return (cast(string) fromStringz(cstr))[0 .. keepingPos];
}
