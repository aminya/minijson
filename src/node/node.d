module minijson.node;

import node_dlang;

import minijson.lib : minifyString;

private extern (C) void atStart(napi_env env)
{
}

mixin exportToJs!(minifyString, MainFunction!atStart);
