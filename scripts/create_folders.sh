#!/bin/bash

PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

echo "=== 2. Создание структуры папок ==="

mkdir -p "$PROJECT_ROOT/build"
mkdir -p "$PROJECT_ROOT/lib"
mkdir -p "$PROJECT_ROOT/toolchain"
mkdir -p "$PROJECT_ROOT/mips_docker/clish_xml"
mkdir -p "$PROJECT_ROOT/mips_docker/lib"

echo "✅ Папка build готова."
echo "✅ Папка lib готова."
echo "✅ Папка toolchain готова."
echo "✅ Папки mips_docker готовыми."

echo "=== Структура директорий готова ==="