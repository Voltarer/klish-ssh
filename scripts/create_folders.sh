#!/bin/bash

PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
WORKSPACE_ROOT="$(cd "$PROJECT_ROOT/.." && pwd)"

LIB_DIR="$PROJECT_ROOT/lib"
REALTEK_DIR="$LIB_DIR/realtek"
LIB_TOOLCHAIN="$WORKSPACE_ROOT/toolchain"

echo "=== 2. Создание структуры папок ==="

mkdir -p "$PROJECT_ROOT/build"
if [ -d "$PROJECT_ROOT/build" ]; then echo "✅ Папка build готова."; fi

mkdir -p "$LIB_DIR"
if [ -d "$LIB_DIR" ]; then echo "✅ Папка lib готова."; fi

mkdir -p "$LIB_TOOLCHAIN"
if [ -d "$LIB_TOOLCHAIN" ]; then echo "✅ Папка toolchain готова."; fi


echo "=== Структура директорий и файлы готовы ==="