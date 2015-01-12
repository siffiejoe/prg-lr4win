@echo off & setlocal

set LR4WIN=@@DIR@@
if not defined LUA_PATH_5_3 set LUA_PATH_5_3=;
set LUA_PATH_5_3=%LR4WIN%\luarocks\2.2\lua\?.lua;%LUA_PATH_5_3%
%LR4WIN%\lua\lua53.exe %LR4WIN%\luarocks\bin\luarocks.lua %*
exit /B %errorlevel%

