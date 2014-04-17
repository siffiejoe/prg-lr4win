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

    luarocks51 list

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
*   `luarocks51.bat`: runs LuaRocks configured for Lua 5.1.
*   `luarocks-admin51.bat`
*   `luarocks52.bat`: runs LuaRocks configured for Lua 5.2.
*   `luarocks-admin52.bat`
*   Compiler commands for MinGW like `gcc`, `mingw32-make`, etc. (Yes,
    you can compile C programs from within the "LuaRocks DosBox" if
    you want to!)


##                           How do I ...                           ##

###                     ... run a Lua program?                     ###

    lua51 myprogram.lua

or

    lua52 myprogram.lua

depending on the Lua version you want to use. (This assumes that the
Lua interpreters are in your `PATH` -- e.g. when using the "LuaRocks
DosBox" -- and that `myprogram.lua` is in your current working
directory.)

###                    ... list installed rocks?                   ###

    luarocks51 list

or

    luarocks52 list

for Lua 5.1 or Lua 5.2, respectively. Initially, there are no rocks
installed.

###                     ... install new rocks?                     ###

Just run

    luarocks51 install xyz

or

    luarocks52 install xyz

to install rock `xyz` for Lua 5.1 or 5.2, respectively. If successful,
the modules can be `require`d normally from within Lua programs. If a
rock installs a command line script, that script is in your `PATH`
automatically (assuming you use the "LuaRocks DosBox").

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

    luarocks51 help

or

    luarocks52 help

###          ... install modules not managed by LuaRocks?          ###

Lua uses path templates in environment variables (plus some builtin
locations) to look for modules. You can print those locations via

    lua51 -e "print(package.path)"
    lua52 -e "print(package.path)"

for Lua modules, and

    lua51 -e "print(package.cpath)"
    lua52 -e "print(package.cpath)"

for compiled C modules. As a convenience the "LuaRocks DosBox" puts
the directories `...\3rdparty\lua\5.1` (or `...\3rdparty\lua\5.2`) for
Lua modules, and `...\3rdparty\lib\5.1` (or `...\3rdparty\lib\5.2`)
for compiled C modules into the mentioned search paths. If a compiled
C module depends on an external DLL, you can put this DLL into
`...\3rdparty\lib`.


##                             Have fun!                            ##

That's all for now. Happy hacking!

