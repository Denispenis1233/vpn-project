#!/usr/bin/env bash
set -e
# Примерный скрипт деплоя на VPS через SSH + запуск Docker Compose
# Требует: ssh доступ, docker и docker-compose на VPS
# Использование:
#   ./deploy.sh user@your.vps.example.com /home/user/deploy-path

if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <user@host> <remote_path>"
  exit 1
fi

TARGET="$1"
REMOTE_DIR="$2"

echo "Копирование файлов на $TARGET:$REMOTE_DIR"
ssh $TARGET "mkdir -p $REMOTE_DIR"
scp -r ./* $TARGET:$REMOTE_DIR/

echo "Запуск docker-compose на удаленном хосте"
ssh $TARGET "cd $REMOTE_DIR && docker-compose up -d"

echo "Готово. Проверьте логи: ssh $TARGET 'cd $REMOTE_DIR && docker-compose logs -f'"
