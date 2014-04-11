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
:: * You will need InnoSetup to actually create the installer.
:: * This build script will only work if the path does not contain
::   spaces (MinGW is a bit picky ...).

:: some variables you might want to configure ...
set LUAV51=5.1.5
set LUAV52=5.2.3
:: For the list/versions of MinGW packages used by default see the
:: :download_mingw subroutine below!
:: The required packages can be found here:
:: http://www.mingw.org/wiki/HOWTO_Install_the_MinGW_GCC_Compiler_Suite#toc1
:: (I added mingw32-make for make-based rocks ...)

:: some variables you probably *DON'T* want to configure ...
set BINDIR=luarocks\win32\bin\bin
set WGET=%BINDIR%\wget.exe
set SZIP=%BINDIR%\7z.exe
set LUAURL=http://www.lua.org/ftp
set MINGWURL=http://downloads.sourceforge.net/project/mingw/MinGW
set BASEDIR="%~dp0"
set LOGFILE="%~dp0build.log"


:: hack to make sure that we can bail out from within nested
:: subroutines without killing the console window
if "%~1" EQU "_GO_" (shift /1 & goto :main)
cmd /C ^""%~f0" _GO_ %*^"
exit /B


:: start of the script
:main
:: make sure that our path does not contain spaces (MinGW will choke!)
if %BASEDIR: =x% NEQ %BASEDIR% (
  echo Argh! Our file path contains spaces. That won't work!
  echo Please run me from a safer location ...
  pause
  exit 1
)
:: put mingw directory into PATH for compiling Lua later
set PATH=%~dp0mingw\bin;%PATH%

:: first create some necessary directories:
mkdir downloads 2>NUL
mkdir mingw 2>NUL
:: empty log file
type NUL > %LOGFILE%

:: download all the necessary stuff from the internet
call :download_lua %LUAV51%
call :download_lua %LUAV52%
call :download_mingw
:: compile lua
call :compile_lua51
call :compile_lua52
:: call InnoSetup if it's in the path
call :find_in_path iscc.exe
if defined _result (
  echo Creating installer ... ^(This may take a while!^)
  "%_result%" lr4win.iss >>%LOGFILE% 2>&1 || call :die
  echo Done.
) else (
  echo Downloading and compiling complete!
  echo Now run InnoSetup to create the installer ...
)
pause
goto :eof


:: helper functions:

:: strip the last extension from a file name
:strip_ext
setlocal
for /F "delims=" %%i in ("%~1") do set _result=%%~ni
endlocal & set _result=%_result%
goto :eof


:: get the filename part of an internet url (using forward slashes)
:url_basename
setlocal
set _var=%1
:url_basename_loop
set _result=%_var:*/=%
if %_result% NEQ %_var% (
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
%WGET% -nc -P downloads %_url% >>%LOGFILE% 2>&1 || call :die
endlocal & set _result=%_result%
goto :eof


:: extract a tarball
:extract_tarball
setlocal
set _tarball=%1
set _dir=%2
call :strip_ext %_tarball%
echo Extracting %_tarball% ...
%SZIP% x -aoa -odownloads downloads\%_tarball% >>%LOGFILE% 2>&1 || call :die
%SZIP% x -aoa -o%_dir% downloads\%_result% >>%LOGFILE% 2>&1 || call :die
endlocal
goto :eof


:: download a lua tarball and extract it
:download_lua
setlocal
set _ver=%1
call :download %LUAURL%/lua-%_ver%.tar.gz
call :extract_tarball %_result% %BASEDIR%
set _dir=lua-%_ver%
call :strip_ext %_dir%
if exist %_result% rmdir /S /Q %_result% >>%LOGFILE% 2>&1
rename %_dir% %_result% >>%LOGFILE% 2>&1 || call :die
endlocal & set _result=%_result%
goto :eof


:: download and extract a single MinGW package
:download_mingw_package
setlocal
set _url=%1
call :download %_url%
call :extract_tarball %_result% mingw
endlocal
goto :eof

:: download and extract all necessary MinGW packages
:download_mingw
setlocal
set BINUTILS_BIN=%MINGWURL%/Base/binutils/binutils-2.24/binutils-2.24-1-mingw32-bin.tar.xz
set BINUTILS_DEV=%MINGWURL%/Base/binutils/binutils-2.24/binutils-2.24-1-mingw32-dev.tar.xz
set MINGWRT_DEV=%MINGWURL%/Base/mingw-rt/mingwrt-4.0.3/mingwrt-4.0.3-1-mingw32-dev.tar.lzma
set MINGWRT_DLL=%MINGWURL%/Base/mingw-rt/mingwrt-4.0.3/mingwrt-4.0.3-1-mingw32-dll.tar.lzma
set W23API_DEV=%MINGWURL%/Base/w32api/w32api-4.0.3/w32api-4.0.3-1-mingw32-dev.tar.lzma
set MPC_DEV=%MINGWURL%/Base/mpc/mpc-1.0.1-2/mpc-1.0.1-2-mingw32-dev.tar.lzma
set MPC_DLL=%MINGWURL%/Base/mpc/mpc-1.0.1-2/mpc-1.0.1-2-mingw32-dll.tar.lzma
set MPFR_DEV=%MINGWURL%/Base/mpfr/mpfr-3.1.2-2/mpfr-3.1.2-2-mingw32-dev.tar.lzma
set MPFR_DLL=%MINGWURL%/Base/mpfr/mpfr-3.1.2-2/mpfr-3.1.2-2-mingw32-dll.tar.lzma
set GMP_DEV=%MINGWURL%/Base/gmp/gmp-5.1.2/gmp-5.1.2-1-mingw32-dev.tar.lzma
set GMP_DLL=%MINGWURL%/Base/gmp/gmp-5.1.2/gmp-5.1.2-1-mingw32-dll.tar.lzma
set PTHREADS_DEV=%MINGWURL%/Base/pthreads-w32/pthreads-w32-2.9.1/pthreads-w32-2.9.1-1-mingw32-dev.tar.lzma
set PTHREADS_DLL=%MINGWURL%/Base/pthreads-w32/pthreads-w32-2.9.1/pthreads-w32-2.9.1-1-mingw32-dll.tar.lzma
set ICONV_DEV=%MINGWURL%/Base/libiconv/libiconv-1.14-3/libiconv-1.14-3-mingw32-dev.tar.lzma
set ICONV_DLL=%MINGWURL%/Base/libiconv/libiconv-1.14-3/libiconv-1.14-3-mingw32-dll.tar.lzma
set ZLIB_DLL=%MINGWURL%/Base/zlib/zlib-1.2.8/zlib-1.2.8-1-mingw32-dll.tar.lzma
set GETTEXT_DLL=%MINGWURL%/Base/gettext/gettext-0.18.3.1-1/gettext-0.18.3.1-1-mingw32-dll.tar.lzma
set GCC_BIN=%MINGWURL%/Base/gcc/Version4/gcc-4.8.1-4/gcc-core-4.8.1-4-mingw32-bin.tar.lzma
set GCC_DEV=%MINGWURL%/Base/gcc/Version4/gcc-4.8.1-4/gcc-core-4.8.1-4-mingw32-dev.tar.lzma
set GCC_DLL=%MINGWURL%/Base/gcc/Version4/gcc-4.8.1-4/gcc-core-4.8.1-4-mingw32-dll.tar.lzma
set MAKE_BIN=%MINGWURL%/Extension/make/make-3.82.90-cvs/make-3.82.90-2-mingw32-cvs-20120902-bin.tar.lzma
call :download_mingw_package %BINUTILS_BIN%
call :download_mingw_package %BINUTILS_DEV%
call :download_mingw_package %MINGWRT_DEV%
call :download_mingw_package %MINGWRT_DLL%
call :download_mingw_package %W23API_DEV%
call :download_mingw_package %MPC_DEV%
call :download_mingw_package %MPC_DLL%
call :download_mingw_package %MPFR_DEV%
call :download_mingw_package %MPFR_DLL%
call :download_mingw_package %GMP_DEV%
call :download_mingw_package %GMP_DLL%
call :download_mingw_package %PTHREADS_DEV%
call :download_mingw_package %PTHREADS_DLL%
call :download_mingw_package %ICONV_DEV%
call :download_mingw_package %ICONV_DLL%
call :download_mingw_package %ZLIB_DLL%
call :download_mingw_package %GETTEXT_DLL%
call :download_mingw_package %GCC_BIN%
call :download_mingw_package %GCC_DEV%
call :download_mingw_package %GCC_DLL%
call :download_mingw_package %MAKE_BIN%
endlocal
goto :eof


:compile_lua51
setlocal
echo Compiling Lua 5.1 ...
for /F "eol=# delims=# tokens=1" %%G in ('findstr /V "^#" lua-5.1\src\Makefile') do @echo %%G>> lua-5.1\src\Makefile.fixed
copy lua-5.1\src\Makefile.fixed lua-5.1\src\Makefile >>%LOGFILE% 2>&1 || call :die
pushd lua-5.1 || call :die
mingw32-make.exe mingw >>%LOGFILE% 2>&1 || call :die
popd
endlocal
goto :eof

:compile_lua52
setlocal
echo Compiling Lua 5.2 ...
pushd lua-5.2 || call :die
mingw32-make.exe mingw >>%LOGFILE% 2>&1 || call :die
popd
endlocal
goto :eof


:find_in_path
setlocal
set _result=%~$PATH:1
endlocal & set _result=%_result%
goto :eof


:: for bailing out when an error occurred
:die
echo Whoa, something went wrong ... Sorry!
echo Check the logfile %LOGFILE% for details ...
pause
exit 1
goto :eof

