#!/bin/bash

PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
SRC_DIR="$PROJECT_ROOT/src"
TARGET_XML_DIR="$PROJECT_ROOT/mips_docker/clish_xml"

echo "=== 5. Синхронизация XML-файлов конфигурации ==="

mkdir -p "$TARGET_XML_DIR"

if [ -d "$SRC_DIR" ]; then
    echo "Копирование XML конфигураций из src/ в mips_docker/clish_xml/..."
    cp -f "$SRC_DIR"/*.xml "$TARGET_XML_DIR/" 2>/dev/null || true
    echo "✅ XML файлы скопированы."
else
    echo "⚠️ Папка src/ не найдена."
fi

echo "=== Синхронизация завершена ==="