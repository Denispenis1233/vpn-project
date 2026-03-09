Проект VPN (скелет)

Содержит:
- `server/` — Docker Compose для WireGuard и скрипт генерации клиентского конфига.
- `flutter-app/` — простой Flutter UI: главный экран с круглой кнопкой подключения и левая панель (меню/настройки).

Важно — ограничения и дальнейшие шаги:
- iOS: требует Apple Developer аккаунт и настройку Network Extension (NEPacketTunnelProvider) — без этого полноценный TUN на iOS нельзя поставить.
- Windows: для полноценного TUN рекомендуется установить WireGuard (драйвер) или использовать `wireguard-go`/официальный клиент.
- Android: можно использовать библиотеку WireGuard (или VPNService) в нативном модуле.

Что сделано:
- Создан UI-скелет на Flutter, эмуляция подключения.
- Подготовлен `docker-compose` для запуска WireGuard-сервера (linuxserver/wireguard) и скрипт для копирования клиентского конфига.

Как запустить сервер (на Linux/VPS или в WSL2/Windows с Docker Desktop):

```bash
cd server
docker-compose up -d
# подождите несколько секунд, затем
./generate-configs.sh
# клиентский конфиг появится как ./client-peer.conf
```

 Дальше могу:
 - Реализовать нативную интеграцию WireGuard для Android (VPNService) и Windows (wireguard-go/interop).
 - Подготовить iOS Network Extension шаблон (нужен доступ к Apple dev account).

CI / Автоматическая сборка .exe
--------------------------------
Если вы хотите, чтобы я автоматически собирал `.exe` и выкладывал сборки при каждом обновлении кода, подключите репозиторий к GitHub и пушьте в ветку `main`.

- В репозитории добавлен workflow: `.github/workflows/windows-build.yml` — он выполняется при пуше в `main` и собирает Windows release, затем загружает zip-архив как артефакт сборки.
- После пуша артефакт доступен в Actions → выбранный workflow → `vpn_app_windows_release` (скачать `release-windows.zip`).

Что нужно от вас:
- Создать публичный или приватный репозиторий на GitHub и запушить содержимое `vpn-project` туда.
- После первого пуша откройте Actions → Build Windows Release и скачайте артефакт.

Если хотите, я могу помочь запушить проект в ваш GitHub (пришлите URL репозитория или добавьте меня как коллаборатра). Также могу настроить автоматическое создание Release и/или инсталлятора при теге — скажите, если нужно.

Скажите, продолжать ли: хочу реализовать подключение на Android и Windows (начать с Android). Также нужно ли мне развернуть сервер на VPS или вы развернёте сами.

Дополнительно:
- Скрипт деплоя на VPS: `server/deploy.sh` — копирует файлы и запускает `docker-compose` на удаленном хосте.
- Windows: к проекту добавлен `vpn_controller.dart` и инструкция по сборке `flutter-app/windows_build_instructions.md`.
 - Windows: добавлены скрипты упаковки и шаблон инсталлятора в `flutter-app/windows/`.
	 - `flutter-app/windows/pack.ps1` — строит релиз и создаёт zip; при наличии Inno Setup запустит сборку инсталлятора.
	 - `flutter-app/windows/installer.iss` — шаблон Inno Setup для создания инсталлятора.
	 - `flutter-app/windows/check_wireguard.ps1` — проверяет наличие WireGuard и открывает страницу загрузки.