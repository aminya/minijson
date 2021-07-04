module jsonminify.wasm;

extern (C): // disable D mangling for wasm exports

import jsonminify.lib : c_minify;

alias minify = c_minify;

void _start()
{
}
