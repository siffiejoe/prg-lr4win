[Setup]
AppName=LuaRocks4Windows
AppId=LuaRocks4WindowsAllInOne
AppVersion=1.0
DefaultDirName="{sd}\LR4Win"
Compression=lzma2
SolidCompression=yes
AllowUNCPath=no
AllowNetworkDrive=no
DisableProgramGroupPage=yes
OutputBaseFilename=LR4WinSetup
OutputDir=.

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
; Lua 5.2
Source: "lua-5.2\src\lua.exe"; DestDir: "{app}\lua"; DestName: "lua52.exe"
Source: "lua-5.2\src\luac.exe"; DestDir: "{app}\lua"; DestName: "luac52.exe"
Source: "lua-5.2\src\lua52.dll"; DestDir: "{app}\lua"
Source: "lua-5.2\src\lua.h"; DestDir: "{app}\lua\include\lua52"
Source: "lua-5.2\src\lualib.h"; DestDir: "{app}\lua\include\lua52"
Source: "lua-5.2\src\lauxlib.h"; DestDir: "{app}\lua\include\lua52"
Source: "lua-5.2\src\luaconf.h"; DestDir: "{app}\lua\include\lua52"
Source: "lua-5.2\src\lua.hpp"; DestDir: "{app}\lua\include\lua52"
; LuaRocks
Source: "luarocks\win32\bin\bin\*"; DestDir: "{app}\tools"
Source: "luarocks\src\luarocks\*"; DestDir: "{app}\luarocks\share\lua\luarocks"; Flags: recursesubdirs
Source: "luarocks\src\bin\luarocks"; DestDir: "{app}\luarocks\bin"; DestName: "luarocks.lua"
Source: "luarocks\src\bin\luarocks-admin"; DestDir: "{app}\luarocks\bin"; DestName: "luarocks-admin.lua"
Source: "templates\config-5.1.lua"; DestDir: "{app}\luarocks\etc"; AfterInstall: CustomizeConfig
Source: "templates\config-5.2.lua"; DestDir: "{app}\luarocks\etc"; AfterInstall: CustomizeConfig
Source: "templates\luarocks51.bat"; DestDir: "{app}\luarocks\bin"; AfterInstall: CustomizeConfig
Source: "templates\luarocks52.bat"; DestDir: "{app}\luarocks\bin"; AfterInstall: CustomizeConfig
Source: "templates\luarocks-admin51.bat"; DestDir: "{app}\luarocks\bin"; AfterInstall: CustomizeConfig
Source: "templates\luarocks-admin52.bat"; DestDir: "{app}\luarocks\bin"; AfterInstall: CustomizeConfig
Source: "templates\site_config51.lua"; DestDir: "{app}\luarocks\share\lua\luarocks\5.1"; DestName: "site_config.lua"; AfterInstall: CustomizeConfig
Source: "templates\site_config52.lua"; DestDir: "{app}\luarocks\share\lua\luarocks\5.2"; DestName: "site_config.lua"; AfterInstall: CustomizeConfig
; Support files
Source: "LuaRocksEnv.bat"; DestDir: "{app}"; AfterInstall: CustomizeConfig

[Dirs]
Name: "{app}\3rdparty\include"
Name: "{app}\3rdparty\lua\5.1"
Name: "{app}\3rdparty\lua\5.2"
Name: "{app}\3rdparty\lib\5.1"
Name: "{app}\3rdparty\lib\5.2"
Name: "{app}\luarocks\share\lua\5.1"
Name: "{app}\luarocks\share\lua\5.2"
Name: "{app}\luarocks\lib\lua\5.1"
Name: "{app}\luarocks\lib\lua\5.2"
Name: "{app}\luarocks\lib\luarocks\rocks-5.1"
Name: "{app}\luarocks\lib\luarocks\rocks-5.2"

[Icons]
Name: "{userdesktop}\LuaRocks DosBox"; Filename: "%COMSPEC%"; Parameters: "/K {app}\LuaRocksEnv.bat"; WorkingDir: "{%USERPROFILE|{app}}"
Name: "{userprograms}\LuaRocks DosBox"; Filename: "%COMSPEC%"; Parameters: "/K {app}\LuaRocksEnv.bat"; WorkingDir: "{%USERPROFILE|{app}}"

[Code]
var
  CancelWithoutPrompt: Boolean;

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
  if (CurPageID = wpSelectDir) and (Pos( ' ', WizardDirValue ) <> 0) then
  begin
    MsgBox( 'Sorry, we can''t have spaces in the installation path!', mbError, MB_OK );
    result := False;
  end;
end;

procedure CancelButtonClick( CurPageID: Integer; var Cancel, Confirm: Boolean );
begin
  if CurPageID = wpInstalling then
    Confirm := not CancelWithoutPrompt;
end;

