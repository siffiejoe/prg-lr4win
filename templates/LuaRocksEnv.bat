@echo off

set LR4WIN=@@DIR@@
set PATH=%LR4WIN%\mingw\bin;%LR4WIN%\lua;%LR4WIN%\3rdparty\lib;%LR4WIN%\nu\lib;%LR4WIN%\luarocks\bin;%PATH%
if not defined LUA_PATH set LUA_PATH=;
set LUA_PATH=%LR4WIN%\luarocks\share\lua\5.1\?.lua;%LR4WIN%\luarocks\share\lua\5.1\?\init.lua;%LR4WIN%\3rdparty\lua\5.1\?.lua;%LR4WIN%\3rdparty\lua\5.1\?\init.lua;%LUA_PATH%
if not defined LUA_CPATH set LUA_CPATH=;
set LUA_CPATH=%LR4WIN%\luarocks\lib\lua\5.1\?.dll;%LR4WIN%\3rdparty\lib\5.1\?.dll;%LUA_CPATH%
if not defined LUA_PATH_5_2 set LUA_PATH_5_2=;
set LUA_PATH_5_2=%LR4WIN%\luarocks\share\lua\5.2\?.lua;%LR4WIN%\luarocks\share\lua\5.2\?\init.lua;%LR4WIN%\3rdparty\lua\5.2\?.lua;%LR4WIN%\3rdparty\lua\5.2\?\init.lua;%LUA_PATH_5_2%
if not defined LUA_CPATH_5_2 set LUA_CPATH_5_2=;
set LUA_CPATH_5_2=%LR4WIN%\luarocks\lib\lua\5.2\?.dll;%LR4WIN%\3rdparty\lib\5.2\?.dll;%LUA_CPATH_5_2%
if not defined LUA_PATH_5_3 set LUA_PATH_5_3=;
set LUA_PATH_5_3=%LR4WIN%\luarocks\share\lua\5.3\?.lua;%LR4WIN%\luarocks\share\lua\5.3\?\init.lua;%LR4WIN%\3rdparty\lua\5.3\?.lua;%LR4WIN%\3rdparty\lua\5.3\?\init.lua;%LUA_PATH_5_3%
if not defined LUA_CPATH_5_3 set LUA_CPATH_5_3=;
set LUA_CPATH_5_3=%LR4WIN%\luarocks\lib\lua\5.3\?.dll;%LR4WIN%\3rdparty\lib\5.3\?.dll;%LUA_CPATH_5_3%

