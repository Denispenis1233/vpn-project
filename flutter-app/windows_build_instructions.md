Сборка Windows .exe (Flutter)

Требования:
- Установленный Flutter SDK с поддержкой Windows: https://flutter.dev/desktop
- Visual Studio (Desktop development with C++)
- Для реального TUN: WireGuard for Windows установлен на клиенте (рекомендуется)

Сборка релиза:

```bash
cd flutter-app
flutter build windows --release
```

После успешной сборки исполняемый файл появится в:

- `flutter-app\build\windows\runner\Release\vpn_app.exe`

Рекомендации для интеграции TUN на Windows:
- Установите WireGuard for Windows (драйвер). Приложение может управлять туннелями через `wireguard.exe`.
- В данном каркасе `vpn_controller.dart` пытается вызвать `wireguard.exe /installtunnelservice <config>`.
- Для полноценной интеграции можно упаковать `client.conf` и вызвать `wireguard.exe` для установки туннеля, либо использовать `wireguard-go` + собственный TUN-адаптер.

Упаковка в инсталлятор:
- Используйте `Inno Setup` или `NSIS` для создания инсталлятора, включите в пакет `vpn_app.exe` и инструкцию по установке `WireGuard`.
