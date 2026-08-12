#!/bin/bash

echo "=== 1. Проверка системных зависимостей (Klish / MIPS) ==="

MISSING_DEPS=0

# Проверка базовых утилит
for cmd in git wget curl autoconf automake libtool make gcc; do
    if ! command -v $cmd &>/dev/null; then
        echo "❌ Утилита '$cmd' не найдена."
        MISSING_DEPS=1
    else
        echo "✅ '$cmd' установлен."
    fi
done

# Проверка build-essential
if ! dpkg -s build-essential &>/dev/null; then
    echo "❌ Пакет 'build-essential' не установлен."
    MISSING_DEPS=1
fi

if [ $MISSING_DEPS -ne 0 ]; then
    echo "⚠️ ОШИБКА: Установите недостающие пакеты перед продолжением:"
    echo "sudo apt-get update && sudo apt-get install -y git build-essential autoconf automake libtool wget curl qemu-user-static"
    exit 1
fi

echo "=== Зависимости в порядке ==="