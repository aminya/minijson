module minijson.wasm;

extern (C): // disable D mangling for wasm exports

public import minijson.libc : minifyString;

void _start()
{
}
