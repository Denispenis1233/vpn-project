; Inno Setup script template for VPN App
[Setup]
AppName=VPN App
AppVersion=0.1
DefaultDirName={pf}\VPN App
DefaultGroupName=VPN App
OutputDir=.
OutputBaseFilename=vpn_app_installer
Compression=lzma2
SolidCompression=yes

[Files]
Source: "{#MyAppExe}"; DestDir: "{app}"; Flags: ignoreversion
; Add other DLLs and resources from Flutter build directory

[Icons]
Name: "{group}\VPN App"; Filename: "{app}\vpn_app.exe"
Name: "{group}\Uninstall VPN App"; Filename: "{uninstallexe}"

; You should replace {#MyAppExe} with the actual path when calling ISCC, for example via command-line preprocessor defines.
