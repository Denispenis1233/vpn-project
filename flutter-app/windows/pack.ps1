# Build and package Flutter Windows app and optionally run Inno Setup to create installer
# Usage: .\pack.ps1

param(
    [string]$ProjectPath = "..\",
    [string]$InnoPath = "C:\\Program Files (x86)\\Inno Setup 6\\ISCC.exe"
)

Push-Location $ProjectPath
Write-Output "Building Flutter Windows release..."
flutter build windows --release

$exe = Join-Path -Path "$ProjectPath\build\windows\runner\Release" -ChildPath "vpn_app.exe"
if (-Not (Test-Path $exe)) {
    Write-Error "Release exe not found: $exe"
    Exit 1
}

$dist = Join-Path -Path $ProjectPath -ChildPath "dist"
if (-Not (Test-Path $dist)) { New-Item -ItemType Directory -Path $dist | Out-Null }

$zip = Join-Path $dist "vpn_app_windows_release.zip"
if (Test-Path $zip) { Remove-Item $zip }

Write-Output "Creating zip: $zip"
Add-Type -AssemblyName System.IO.Compression.FileSystem
[IO.Compression.ZipFile]::CreateFromDirectory((Join-Path $ProjectPath "build\windows\runner\Release"), $zip)

if (Test-Path $InnoPath) {
    Write-Output "Running Inno Setup to create installer..."
    & $InnoPath (Join-Path $ProjectPath "windows\installer.iss")
} else {
    Write-Output "Inno Setup not found at $InnoPath; skipping installer creation. You can create installer manually using installer.iss"
}

Pop-Location
Write-Output "Packaging complete. Output in $dist"