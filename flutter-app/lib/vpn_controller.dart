import 'dart:io';

class VpnController {
  // Write a minimal client config to a temp file and return its path.
  static Future<String> _writeConfig() async {
    final config = '''[Interface]
PrivateKey = REPLACE_WITH_PRIVATE_KEY
Address = 10.0.0.2/24
DNS = 1.1.1.1

[Peer]
PublicKey = REPLACE_WITH_SERVER_PUBLIC_KEY
Endpoint = your.vps.example.com:51820
AllowedIPs = 0.0.0.0/0
''';
    final dir = Directory.systemTemp.createTempSync('vpn_app_');
    final file = File('${dir.path}/client.conf');
    await file.writeAsString(config);
    return file.path;
  }

  // Detect presence of WireGuard for Windows (wireguard.exe) in PATH.
  static Future<String?> _whichWireGuardExe() async {
    try {
      final result = await Process.run('where', ['wireguard.exe']);
      if (result.exitCode == 0) {
        final out = (result.stdout as String).trim().split(RegExp(r'\r?\n'));
        if (out.isNotEmpty) return out.first;
      }
    } catch (_) {}
    return null;
  }

  // Start VPN (Windows). Prefer official WireGuard if installed; otherwise print instructions.
  static Future<void> start() async {
    if (!Platform.isWindows) return;
    final cfg = await _writeConfig();

    final wgExe = await _whichWireGuardExe();
    if (wgExe != null) {
      try {
        final result = await Process.run(wgExe, ['/installtunnelservice', cfg]);
        if (result.exitCode != 0) {
          print('wireguard.exe returned non-zero: ${result.stderr}');
        } else {
          print('Tunnel installed: ${result.stdout}');
        }
      } catch (e) {
        print('Failed to run wireguard.exe: $e');
      }
      return;
    }

    // If WireGuard not installed, try to find bundled wireguard-go (optional) and instruct user.
    print('WireGuard for Windows not found in PATH. To enable real TUN you must install WireGuard for Windows or provide wireguard-go and Wintun driver.');
    print('Temporary config written to: $cfg');
  }

  // Stop VPN (Windows). Attempts to uninstall tunnel service via wireguard.exe.
  static Future<void> stop() async {
    if (!Platform.isWindows) return;
    final wgExe = await _whichWireGuardExe();
    if (wgExe != null) {
      try {
        final result = await Process.run(wgExe, ['/uninstalltunnelservice']);
        print('Uninstall result: ${result.stdout} ${result.stderr}');
      } catch (e) {
        print('Failed to run wireguard.exe to uninstall tunnel: $e');
      }
      return;
    }
    print('WireGuard not found; nothing to stop. If you used wireguard-go, stop that process manually.');
  }
}
