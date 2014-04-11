@echo off & setlocal

set LR4WIN=@@DIR@@
if not defined LUA_PATH_5_2 set LUA_PATH_5_2=;
set LUA_PATH_5_2=%LR4WIN%\luarocks\2.1\lua\?.lua;%LUA_PATH_5_2%
%LR4WIN%\lua\lua52.exe %LR4WIN%\luarocks\bin\luarocks.lua %*
exit /B %errorlevel%

