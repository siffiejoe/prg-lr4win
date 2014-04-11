local LR4WIN = [===[@@DIR@@]===]
return {
  LUA_INCDIR=LR4WIN..[[\lua\include\lua51]],
  LUA_LIBDIR=LR4WIN..[[\lua]],
  LUA_BINDIR=LR4WIN..[[\lua]],
  LUA_INTERPRETER=LR4WIN..[[\lua\lua51.exe]],
  LUAROCKS_UNAME_S=[[MINGW]],
  LUAROCKS_UNAME_M=[[x86]],
  LUAROCKS_SYSCONFIG=LR4WIN..[[\luarocks\etc\luarocks\config-5.1.lua]],
  LUAROCKS_ROCKS_TREE=LR4WIN..[[\luarocks]],
  LUAROCKS_ROCKS_SUBDIR=[[\lib\luarocks\rocks-5.1]],
  LUAROCKS_PREFIX=LR4WIN..[[\luarocks]],
  LUAROCKS_DOWNLOADER=[[wget]],
  LUAROCKS_MD5CHECKER=[[md5sum]],
  LUAROCKS_FORCE_CONFIG=true,
}

