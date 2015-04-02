@echo off & setlocal

:: Script which calls NuGet.exe to download and install NuGet packages
:: and copies DLLs and header files to places where LuaRocks can find
:: them.

set LR4WIN=@@DIR@@

:: we only hijack the install command of nuget
if /I NOT [%1]==[install] goto :plainnuget

:: check whether necessary rocks are installed
%LR4WIN%\lua\lua52.exe -e "require'lfs'" 2>NUL || goto :lfsmissing
%LR4WIN%\lua\lua52.exe -e "require'pe-parser'" 2>NUL || goto :pemissing

:: run nuget with the correct output directory
%LR4WIN%\nu\nuget.exe %* -OutputDirectory %LR4WIN%\nu\packages
if errorlevel 1 goto :eof

:: update ...\nu\include and ...\nu\lib
echo Updating '%LR4WIN%\nu\include' and '%LR4WIN%\nu\lib' ...
::%LR4WIN%\lua\lua52.exe %LR4WIN%\nu\nuupdate.lua %LR4WIN%
goto :eof


:lfsmissing
call :missingrock luafilesystem
exit /b 1
goto :eof

:pemissing
call :missingrock pe-parser
exit /b 1
goto :eof

:: print nice error message in case a rock is missing
:missingrock
echo We are missing a rock necessary for postprocessing installed NuGet packages^!
echo Install it using:
echo ^ ^ luarocks-5.2 install %1
echo ^(Required rocks: luafilesystem, pe-parser^)
goto :eof


:: for some nuget commands we have nothing to do but pass all options
:: to the nuget executable
:plainnuget
%LR4WIN%\nu\nuget.exe %*
goto :eof

