; version number of the "LuaRocks 4 Windows" package (derived from the
; LuaRocks version number plus a simple counter)
#define VERSION "2.4.1.1"
; you can disable support for the supported package managers here
; to make the installer executable smaller:
;#define YYPKG
;#define NUGET

[Setup]
AppName="LuaRocks 4 Windows"
AppId=LuaRocks4WindowsAllInOne
AppVersion={#VERSION}
VersionInfoVersion={#VERSION}
DefaultDirName="{code:DefDirRoot}\LR4Win"
DefaultGroupName="LuaRocks 4 Windows"
Compression=lzma2
SolidCompression=yes
AllowUNCPath=no
AllowNetworkDrive=no
AllowNoIcons=yes
LicenseFile="licenses.txt"
OutputBaseFilename=LR4WinSetup
OutputDir=.
PrivilegesRequired=none

[Files]
; MinGW
Source: "mingw\*"; DestDir: "{app}\mingw"; Flags: recursesubdirs
; Lua 5.1
Source: "lua-5.1\src\lua.exe"; DestDir: "{app}\lua"; DestName: "lua51.exe"
Source: "lua-5.1\src\luac.exe"; DestDir: "{app}\lua"; DestName: "luac51.exe"
Source: "lua-5.1\src\lua51.dll"; DestDir: "{app}\lua"
Source: "lua-5.1\src\lua.h"; DestDir: "{app}\lua\include\lua51"
Source: "lua-5.1\src\lualib.h"; DestDir: "{app}\lua\include\lua51"
Source: "lua-5.1\src\lauxlib.h"; DestDir: "{app}\lua\include\lua51"
Source: "lua-5.1\src\luaconf.h"; DestDir: "{app}\lua\include\lua51"
Source: "lua-5.1\doc\*"; DestDir: "{app}\lua\manual\5.1"
; Lua 5.2
Source: "lua-5.2\src\lua.exe"; DestDir: "{app}\lua"; DestName: "lua52.exe"
Source: "lua-5.2\src\luac.exe"; DestDir: "{app}\lua"; DestName: "luac52.exe"
Source: "lua-5.2\src\lua52.dll"; DestDir: "{app}\lua"
Source: "lua-5.2\src\lua.h"; DestDir: "{app}\lua\include\lua52"
Source: "lua-5.2\src\lualib.h"; DestDir: "{app}\lua\include\lua52"
Source: "lua-5.2\src\lauxlib.h"; DestDir: "{app}\lua\include\lua52"
Source: "lua-5.2\src\luaconf.h"; DestDir: "{app}\lua\include\lua52"
Source: "lua-5.2\src\lua.hpp"; DestDir: "{app}\lua\include\lua52"
Source: "lua-5.2\doc\*"; DestDir: "{app}\lua\manual\5.2"
; Lua 5.3
Source: "lua-5.3\src\lua.exe"; DestDir: "{app}\lua"; DestName: "lua53.exe"
Source: "lua-5.3\src\luac.exe"; DestDir: "{app}\lua"; DestName: "luac53.exe"
Source: "lua-5.3\src\lua53.dll"; DestDir: "{app}\lua"
Source: "lua-5.3\src\lua.h"; DestDir: "{app}\lua\include\lua53"
Source: "lua-5.3\src\lualib.h"; DestDir: "{app}\lua\include\lua53"
Source: "lua-5.3\src\lauxlib.h"; DestDir: "{app}\lua\include\lua53"
Source: "lua-5.3\src\luaconf.h"; DestDir: "{app}\lua\include\lua53"
Source: "lua-5.3\src\lua.hpp"; DestDir: "{app}\lua\include\lua53"
Source: "lua-5.3\doc\*"; DestDir: "{app}\lua\manual\5.3"
; LuaRocks
Source: "luarocks\win32\tools\*"; DestDir: "{app}\tools"
Source: "luarocks\src\luarocks\*"; DestDir: "{app}\luarocks\2.2\lua\luarocks"; Flags: recursesubdirs
Source: "luarocks\win32\rclauncher.c"; DestDir: "{app}\luarocks\2.2";
Source: "luarocks\src\bin\luarocks"; DestDir: "{app}\luarocks\bin"; DestName: "luarocks.lua"
Source: "luarocks\src\bin\luarocks-admin"; DestDir: "{app}\luarocks\bin"; DestName: "luarocks-admin.lua"
Source: "templates\config-5.1.lua"; DestDir: "{app}\luarocks\etc\luarocks"; AfterInstall: CustomizeConfig
Source: "templates\config-5.2.lua"; DestDir: "{app}\luarocks\etc\luarocks"; AfterInstall: CustomizeConfig
Source: "templates\config-5.3.lua"; DestDir: "{app}\luarocks\etc\luarocks"; AfterInstall: CustomizeConfig
Source: "templates\luarocks-5.1.bat"; DestDir: "{app}\luarocks\bin"; AfterInstall: CustomizeConfig
Source: "templates\luarocks-5.2.bat"; DestDir: "{app}\luarocks\bin"; AfterInstall: CustomizeConfig
Source: "templates\luarocks-5.3.bat"; DestDir: "{app}\luarocks\bin"; AfterInstall: CustomizeConfig
Source: "templates\luarocks-admin-5.1.bat"; DestDir: "{app}\luarocks\bin"; AfterInstall: CustomizeConfig
Source: "templates\luarocks-admin-5.2.bat"; DestDir: "{app}\luarocks\bin"; AfterInstall: CustomizeConfig
Source: "templates\luarocks-admin-5.3.bat"; DestDir: "{app}\luarocks\bin"; AfterInstall: CustomizeConfig
Source: "templates\site_config_5_1.lua"; DestDir: "{app}\luarocks\2.2\lua\luarocks"; AfterInstall: CustomizeConfig
Source: "templates\site_config_5_2.lua"; DestDir: "{app}\luarocks\2.2\lua\luarocks"; AfterInstall: CustomizeConfig
Source: "templates\site_config_5_3.lua"; DestDir: "{app}\luarocks\2.2\lua\luarocks"; AfterInstall: CustomizeConfig
#ifdef YYPKG
; Win-Builds/yypkg
Source: "yypkgs\*"; DestDir: "{app}\yypkgs"; Flags: recursesubdirs createallsubdirs;Tasks: installyypkg
#endif
#ifdef NUGET
; NuGet
Source: "downloads\nuget.exe"; DestDir: "{app}\nu"; Tasks: installnuget
Source: "templates\nuget.bat"; DestDir: "{app}\luarocks\bin"; Tasks: installnuget; AfterInstall: CustomizeConfig
Source: "templates\nuupdate.lua"; DestDir: "{app}\nu"; Tasks: installnuget
#endif
; Support files
Source: "templates\LuaRocksEnv.bat"; DestDir: "{app}"; AfterInstall: CustomizeConfig
Source: "licenses.txt"; DestDir: "{app}"
Source: "luarocks.url"; DestDir: "{app}"
Source: "readme.txt"; DestDir: "{app}"; Flags: isreadme

[Dirs]
Name: "{app}\3rdparty\include"
Name: "{app}\3rdparty\lua\5.1"
Name: "{app}\3rdparty\lua\5.2"
Name: "{app}\3rdparty\lua\5.3"
Name: "{app}\3rdparty\lib\5.1"
Name: "{app}\3rdparty\lib\5.2"
Name: "{app}\3rdparty\lib\5.3"
#ifdef NUGET
Name: "{app}\nu\packages"; Tasks: installnuget
Name: "{app}\nu\include"; Tasks: installnuget
Name: "{app}\nu\lib"; Tasks: installnuget
#endif
Name: "{app}\luarocks\share\lua\5.1"
Name: "{app}\luarocks\share\lua\5.2"
Name: "{app}\luarocks\share\lua\5.3"
Name: "{app}\luarocks\lib\lua\5.1"
Name: "{app}\luarocks\lib\lua\5.2"
Name: "{app}\luarocks\lib\lua\5.3"
Name: "{app}\luarocks\lib\luarocks\rocks-5.1"
Name: "{app}\luarocks\lib\luarocks\rocks-5.2"
Name: "{app}\luarocks\lib\luarocks\rocks-5.3"

[Tasks]
Name: desktopicon; Description: "Create a &desktop icon"; GroupDescription: "Additional icons:"
Name: desktopicon\common; Description: "For all users"; GroupDescription: "Additional icons:"; Flags: exclusive; Check: IsPrivileged
Name: desktopicon\user; Description: "For the current user only"; GroupDescription: "Additional icons:"; Flags: exclusive unchecked; Check: IsPrivileged
#ifdef YYPKG
Name: installyypkg; Description: "Install YYPKG package manager"
#endif
#ifdef NUGET
Name: installnuget; Description: "Install NuGet and support files"; Flags: unchecked
#endif

[Icons]
Name: "{commondesktop}\LuaRocks DosBox"; Filename: "%COMSPEC%"; Parameters: "/K {app}\LuaRocksEnv.bat"; WorkingDir: "%USERPROFILE%"; Tasks: desktopicon\common
Name: "{userdesktop}\LuaRocks DosBox"; Filename: "%COMSPEC%"; Parameters: "/K {app}\LuaRocksEnv.bat"; WorkingDir: "%USERPROFILE%"; Tasks: desktopicon and (not desktopicon\common)
Name: "{group}\LuaRocks DosBox"; Filename: "%COMSPEC%"; Parameters: "/K {app}\LuaRocksEnv.bat"; WorkingDir: "%USERPROFILE%"
#ifdef YYPKG
Name: "{group}\YYPKG package manager"; Filename: "{app}\yypkgs\bin\yypkg-1.5.0.exe"; Tasks: installyypkg
#endif
Name: "{group}\Show Readme"; Filename: "{app}\readme.txt"
Name: "{group}\LuaRocks Documentation"; Filename: "{app}\luarocks.url"
Name: "{group}\Lua 5.1 Manual"; Filename: "{app}\lua\manual\5.1\contents.html"
Name: "{group}\Lua 5.2 Manual"; Filename: "{app}\lua\manual\5.2\contents.html"
Name: "{group}\Lua 5.3 Manual"; Filename: "{app}\lua\manual\5.3\contents.html"
Name: "{group}\Uninstall LuaRocks"; Filename: "{uninstallexe}"

[Code]
var
  CancelWithoutPrompt: Boolean;

function IsPrivileged(): Boolean;
begin
  result := IsAdminLoggedOn or IsPowerUserLoggedOn;
end;

function ContainsSpace( Param: String ): Boolean;
begin
  result := (Pos( ' ', Param ) <> 0);
end;

function DefDirRoot( Param: String ): String;
var
  UserProfile: String;
begin
  if IsPrivileged then
    result := ExpandConstant( '{sd}' )
  else begin
    UserProfile := ExpandConstant( '{%USERPROFILE|{sd}}' );
    if ContainsSpace( UserProfile ) then
      result := ExpandConstant( '{sd}' )
    else
      result := UserProfile;
  end;
end;

// see http://stackoverflow.com/questions/20174359/replace-a-text-in-a-file-with-inno-setup
function FileReplaceString( const FileName, SearchString, ReplaceString: String ): Boolean;
var
  MyFile : TStrings;
  MyText : String;
begin
  MyFile := TStringList.Create;
  try
    result := True;
    try
      MyFile.LoadFromFile( FileName );
      MyText := MyFile.Text;
      if StringChangeEx( MyText, SearchString, ReplaceString, True ) > 0 then
      begin
        MyFile.Text := MyText;
        MyFile.SaveToFile( FileName );
      end;
    except
      result := False;
    end;
  finally
    MyFile.Free;
  end;
end;

// AfterInstall hook for some config files
procedure CustomizeConfig();
var
  RealFileName: String;
begin
  RealFileName := ExpandConstant( CurrentFileName );
  if not FileReplaceString( RealFileName, '@@DIR@@', ExpandConstant('{app}') ) then
  begin
    MsgBox( 'Failed to customize a LuaRocks config file ' + RealFileName, mbError, MB_OK );
    CancelWithoutPrompt := True;
    WizardForm.Close
  end;
end;

function InitializeSetup(): Boolean;
begin
  CancelWithoutPrompt := False;
  result := True;
end;

// check that the installation path doesn't contain spaces
function NextButtonClick( CurPageID: Integer ): Boolean;
begin
  result := True;
  if (CurPageID = wpSelectDir) and ContainsSpace( WizardDirValue ) then
  begin
    MsgBox( 'Sorry, we can''t have spaces in the installation path!', mbError, MB_OK );
    result := False;
  end;
end;

// make an installation error rollback without asking the user
procedure CancelButtonClick( CurPageID: Integer; var Cancel, Confirm: Boolean );
begin
  if CurPageID = wpInstalling then
    Confirm := not CancelWithoutPrompt;
end;

