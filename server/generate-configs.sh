#!/usr/bin/env bash
set -e
# Запускает контейнер и копирует первый найденный клиентский конфиг в корень папки
cd "$(dirname "$0")"

docker-compose up -d
echo "Ожидаю инициализации контейнера..."
sleep 6
CONFIG_DIR=./config
PEER_CONF=$(find "$CONFIG_DIR" -type f -name "*.conf" | head -n 1)
if [ -z "$PEER_CONF" ]; then
  echo "Не найден клиентский конфиг в $CONFIG_DIR. Посмотрите логи контейнера: docker-compose logs wireguard"
  exit 1
fi
cp "$PEER_CONF" ./client-peer.conf
echo "Клиентский конфиг скопирован в ./client-peer.conf"
