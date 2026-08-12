#!/bin/bash

echo "=== 1. Проверка системных зависимостей ==="

# Флаг для отслеживания ошибок
MISSING_DEPS=0

# Проверка Git
if ! command -v git &>/dev/null; then
    echo "❌ Утилита 'git' не найдена."
    MISSING_DEPS=1
else
    echo "✅ 'git' установлен."
fi

# 2. Проверка пакета build-essential
if ! dpkg -s build-essential &>/dev/null; then
    echo "❌ Пакет 'build-essential' не установлен."
    MISSING_DEPS=1
else
    echo "✅ Пакет 'build-essential' установлен."
fi

# Проверка утилит для скачивания
if ! command -v wget &>/dev/null && ! command -v curl &>/dev/null; then
    echo "❌ Не найдены wget или curl."
    MISSING_DEPS=1
else
    echo "✅ wget/curl найдены."
fi

# Итог проверки
if [ $MISSING_DEPS -ne 0 ]; then
    echo "⚠️ ОШИБКА: Установите недостающие пакеты перед продолжением."
    echo "Выполните следующую команду для установки:"
    echo "sudo apt-get update && sudo apt-get install -y git default-jre build-essential wget curl"
    exit 1
fi

echo "=== Зависимости в порядке ==="