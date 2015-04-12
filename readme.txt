#                         LuaRocks 4 Windows                         #

Welcome! It seems you have successfully installed "LuaRocks 4 Windows"
(we will confirm that in a moment), a binary LuaRocks distribution
which includes multiple different Lua interpreters, LuaRocks
configured for all those Lua interpreters, and a recent MinGW C
compiler.


##                             First Run                            ##

You should find a link "LuaRocks DosBox" in your start menu, and/or on
your desktop. If you didn't install any of those links (you better
should have!), you can have a look at the file `LuaRocksEnv.bat` in
the installation directory for the necessary environment changes you
have to make yourself now. You will still need some form of command
line interface for installing rocks and/or running Lua programs, since
both LuaRocks and Lua are command line applications.

So now open a "LuaRocks DosBox" and type the following:

    lua51 -v

and

    luarocks-5.1 list

The first command should tell you version and copyright information
about the included Lua interpreter (version 5.1), while the second
should print an empty list (there are no rocks installed yet). If both
work as expected, you are good to go ...


##                     Installed Files/Programs                     ##

The installer should have installed the following files/programs (if
you use the "LuaRocks DosBox" all programs should be in your `PATH`):

*   `lua51.exe`: the interpreter for Lua 5.1.
*   `luac51.exe`: the compiler for Lua 5.1.
*   DLL and include files for Lua 5.1. You don't need to know the
    details, LuaRocks is configured to take care of that for you.
*   The manual for Lua 5.1 in HTML format. You will find a link in the
    start menu.
*   `lua52.exe`: the interpreter for Lua 5.2.
*   `luac52.exe`: the compiler for Lua 5.2.
*   DLL and include files for Lua 5.2.
*   The manual for Lua 5.2 in HTML format.
*   `lua53.exe`: the interpreter for Lua 5.3.
*   `luac53.exe`: the compiler for Lua 5.3.
*   DLL and include files for Lua 5.3.
*   The manual for Lua 5.3 in HTML format.
*   `luarocks-5.1.bat`: runs LuaRocks configured for Lua 5.1.
*   `luarocks-admin-5.1.bat`
*   `luarocks-5.2.bat`: runs LuaRocks configured for Lua 5.2.
*   `luarocks-admin-5.2.bat`
*   `luarocks-5.3.bat`: runs LuaRocks configured for Lua 5.3.
*   `luarocks-admin-5.3.bat`
*   Compiler commands for MinGW like `gcc`, `mingw32-make`, etc. (Yes,
    you can compile C programs from within the "LuaRocks DosBox" if
    you want to!)
*   If you have selected the experimental `nuget` task during
    installation, you have access to the `nuget.bat` command. This
    batch file calls the standard NuGet command line client, and a
    custom Lua script for postprocessing the installed packages
    afterwards.


##                           How do I ...                           ##

###                     ... run a Lua program?                     ###

    lua51 myprogram.lua

or

    lua52 myprogram.lua

or

    lua53 myprogram.lua

depending on the Lua version you want to use. (This assumes that the
Lua interpreters are in your `PATH` -- e.g. when using the "LuaRocks
DosBox" -- and that `myprogram.lua` is in your current working
directory.)

###                    ... list installed rocks?                   ###

    luarocks-5.1 list

or

    luarocks-5.2 list

or

    luarocks-5.3 list

for Lua 5.1, Lua 5.2, or Lua 5.3, respectively. Initially, there are
no rocks installed.

###                     ... install new rocks?                     ###

Just run

    luarocks-5.1 install xyz

or

    luarocks-5.2 install xyz

or

    luarocks-5.3 install xyz

to install rock `xyz` for Lua 5.1, 5.2, or 5.3, respectively. If
successful, the modules can be `require`d normally from within Lua
programs. If a rock installs a command line script, that script is in
your `PATH` automatically (assuming you use the "LuaRocks DosBox").

###     ... install a rock that depends on an external library?    ###

Some rocks provide bindings for some external library, and compiling
that binding requires access to that library and its include files.
LuaRocks will tell you that by requesting `XYZ_DIR` variables (or
similar) on the command line. LuaRocks by design does *not* help you
with building those external libraries. Fortunately you can often
download precompiled DLLs and import libraries for Windows (sometimes
the include files are included, sometimes you have to search for them
in the source archives). When you have somehow obtained those
libraries and include files, you can do as LuaRocks has asked -- set
the mentioned `*_DIR` variables, or you can put the include files into
`...\3rdparty\include`, and the libraries into `...\3rdparty\lib`
(where `...` is the installation directory of "LuaRocks 4 Windows").
For convenience the "LuaRocks DosBox" configures LuaRocks to look
there by default, and the `lib` directory also is in the `PATH`, so
that DLLs can be found at runtime.

###       ... learn about all those other LuaRocks commands?       ###

You should read the documentation on the LuaRocks homepage (there is a
link in the start menu), but for a quick overview you can use:

    luarocks-5.1 help

or

    luarocks-5.2 help

or

    luarocks-5.3 help

###          ... install modules not managed by LuaRocks?          ###

Lua uses path templates in environment variables (plus some builtin
locations) to look for modules. You can print those locations via

    lua51 -e "print(package.path)"
    lua52 -e "print(package.path)"
    lua53 -e "print(package.path)"

for Lua modules, and

    lua51 -e "print(package.cpath)"
    lua52 -e "print(package.cpath)"
    lua53 -e "print(package.cpath)"

for compiled C modules. As a convenience the "LuaRocks DosBox" puts
the directories `...\3rdparty\lua\5.x` (where `x` is 1, 2, or 3) for
Lua modules, and `...\3rdparty\lib\5.x` for compiled C modules into
the mentioned search paths. If a compiled C module depends on an
external DLL, you can put this DLL into `...\3rdparty\lib`.

###     ... install libraries and include files for C modules?     ###

If you have selected the experimental NuGet feature during
installation of "LuaRocks 4 Windows", you can install some native
packages from the NuGet repository. E.g.:

    nuget install expat
    luarocks-5.2 install luaexpat

First you will need to install some additional rocks for the
postprocessing of the NuGet packages -- calling `nuget` should tell
you which ones. The postprocessing will copy include files from the
installed packages to `...\nu\include` and DLLs to `...\nu\lib` where
LuaRocks can find them. The installed packages are stored in
`...\nu\packages` (in case you need additional files, e.g. import
libraries or documentation).

If you didn't enable the experimental NuGet feature, or if the desired
library is not in the NuGet gallery, you have to install the DLLs and
header files by hand. Use the `...\3rdparty\lib` and
`...\3rdparty\include` directories for that.

##                             Have fun!                            ##

That's all for now. Happy hacking!

