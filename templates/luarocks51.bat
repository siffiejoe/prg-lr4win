@echo off & setlocal

set LR4WIN=@@DIR@@
if not defined LUA_PATH set LUA_PATH=;
set LUA_PATH=%LR4WIN%\luarocks\2.2\lua\?.lua;%LUA_PATH%
%LR4WIN%\lua\lua51.exe %LR4WIN%\luarocks\bin\luarocks.lua %*
exit /B %errorlevel%

