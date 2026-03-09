# Checks for WireGuard installation and optionally opens download page
$wg = Get-Command wireguard.exe -ErrorAction SilentlyContinue
if ($wg) {
    Write-Output "WireGuard found: $($wg.Source)"
} else {
    Write-Output "WireGuard not found in PATH. Download from: https://www.wireguard.com/install/"
    Start-Process "https://www.wireguard.com/install/"
}
