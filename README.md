#                             prg-lr4win                             #

LuaRocks installer for Windows bundling Lua 5.1, Lua 5.2, Lua 5.3, and
the MinGW compiler.

##                        Build Instructions                        ##

Prerequisites:

*   a Windows OS
*   [Inno Setup][1] (tested with 5.5.4 (u))
*   git (e.g. [git for Windows][2]) (optional, see below)
*   the rest will be downloaded during the build

  [1]: http://www.jrsoftware.org/isinfo.php
  [2]: http://msysgit.github.io/

How to build:

1.  Clone [this repository][3] using the `--recursive` flag (to
    include the [LuaRocks][4] submodule). As an alternative you could
    download the zip files for both Github projects and extract them
    to the correct locations (in this case you don't need git). Make
    sure that the path of the cloned/downloaded repository doesn't
    contain spaces (MinGW doesn't like spaces in the executable
    paths).
2.  Execute `build.bat` (either via a DosBox from within the cloned
    repository directory, or by double-clicking in Windows Explorer).
    This will download and extract the source code for Lua (5.1, 5.2,
    and 5.3), download a minimal binary MinGW installation from
    Sourceforge, and compile the Lua source code using the downloaded
    C compiler. As long as you keep the downloaded files you don't
    need to run `build.bat` again.
3.  If downloading and compilation were successful, you can create the
    installer executable by compiling `lr4win.iss` using Inno Setup.
    The resulting file will be `LR4WinSetup.exe` in the top level
    repository directory.

  [3]: https://github.com/siffiejoe/prg-lr4win
  [4]: https://github.com/keplerproject/luarocks


##                         Use Instructions                         ##

After installation you should have a link to a "LuaRocks DosBox" in
your start menu and/or on your desktop. This link starts a command
prompt and sets the necessary environment variables for LuaRocks, Lua,
and MinGW to run properly.

From within the "LuaRocks DosBox" the following should work:

*  Running `lua51` and `luac51`.
*  Running `lua52` and `luac52`.
*  Running `lua53` and `luac53`.
*  Running `luarocks-5.1` and `luarocks-admin-5.1`.
*  Running `luarocks-5.2` and `luarocks-admin-5.2`.
*  Running `luarocks-5.3` and `luarocks-admin-5.3`.
*  Running the MinGW compiler tools.
*  Include files in `...\3rdparty\include` should be picked up by
   LuaRocks automatically when you build a C module (in addition to
   the appropriate Lua include files, obviously).
*  Libraries in `...\3rdparty\lib` should be picked up by LuaRocks
   automatically when you build a C module (in addition to the
   appropriate Lua libraries; loading dynamic libraries from that
   directory should work as well).
*  Scripts installed via LuaRocks should be in PATH automatically.
*  `lua51` should also find Lua modules in `...\3rdparty\lua\5.1` and
   C modules in `...\3rdparty\lib\5.1`.
*  `lua52` should also find Lua modules in `...\3rdparty\lua\5.2` and
   C modules in `...\3rdparty\lib\5.2`.
*  `lua53` should also find Lua modules in `...\3rdparty\lua\5.3` and
   C modules in `...\3rdparty\lib\5.3`.
*  If you have enabled the experimental NuGet support during
   installation, the `nuget` command should install and postprocess
   packages from the NuGet gallery, so that LuaRocks can find include
   files and DLLs (using `...\nu\include` and `...\nu\lib`).

If you don't want to use the "LuaRocks DosBox", you can have a look at
`...\LuaRocksEnv.bat` for the necessary environment changes and apply
them yourself.

