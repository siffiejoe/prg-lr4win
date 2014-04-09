@echo off & setlocal

:: Build script which downloads the sources for Lua 5.1 and 5.2, and
:: builds both versions using custom names/directories, so that they
:: can coexist better. Also downloads a minimal MinGW C compiler.
:: Finally creates an install wizard using InnoSetup.
::
:: Requirements:
:: * You need the sources of LuaRocks. Hopefully you cloned this git
::   repository using the --recursive flag. If not: execute
::     git submodule update --init
::   to get the submodule containing LuaRocks's source code.
:: * You will need an existing installation of MinGW for building the
::   Lua binaries with the bin directory in your PATH.
:: * You will need InnoSetup to actually create the installer.

:: some variables you might want to configure ...
set LUAV51=5.1.5
set LUAV52=5.2.3


:: some variables you probably *DON'T* want to configure ...
set BINDIR=luarocks\win32\bin\bin
set WGET=%BINDIR%\wget.exe
set SZIP=%BINDIR%\7z.exe
set LUAURL=http://www.lua.org/ftp
set BASEDIR=%~dp0


if "%~1" EQU "_GO_" goto :main
cmd /c ^""%~f0" _GO_ %*^"
exit /B

:: start of the script
:main
shift /1

:: first create some necessary directories:
mkdir downloads 2>NUL
mkdir mingw 2>NUL

:: TODO tests
call :download_lua %LUAV51%
call :download_lua %LUAV52%


:: we are done
echo Ok, done!
goto :eof




:: helper functions:

:: strip the last extension from a file name
:basename
setlocal
for /F "delims=" %%i in ("%1") do set _result=%%~ni
endlocal & set _result=%_result%
goto :eof


:: get the filename part of an internet url (using forward slashes)
:url_basename
setlocal
set _var=%1
:url_basename_loop
set _result=%_var:*/=%
if /%_result%/ NEQ /%_var%/ (
  set _var=%_result%
  goto :url_basename_loop
)
endlocal & set _result=%_result%
goto :eof


:: download a file from the internet using wget
:download
setlocal
set _url=%1
call :url_basename %_url%
echo Downloading %_url% ...
%WGET% -q -nc -P downloads %_url% >NUL 2>NUL || call :die
endlocal & set _result=%_result%
goto :eof


:: download a lua tarball and extract it
:download_lua
setlocal
set _ver=%1
call :download %LUAURL%/lua-%_ver%.tar.gz
call :extract_tarball %_result% %BASEDIR%
set _dir=lua-%_ver%
call :basename %_dir%
if exist %_result% rmdir /S /Q %_result%
rename %_dir% %_result% || call :die
endlocal & set _result=%_result%
goto :eof


:: extract a tarball
:extract_tarball
setlocal
set _tarball=%1
set _dir=%2
call :basename %_tarball%
echo Extracting %_tarball% ...
%SZIP% x -aoa -odownloads downloads\%_tarball% >NUL 2>NUL || call :die
%SZIP% x -aoa -o%_dir% downloads\%_result% >NUL 2>NUL || call :die
endlocal
goto :eof


:: for bailing out when an error occurred
:die
echo Whoa something went wrong ... Sorry!
exit 1
goto :eof


