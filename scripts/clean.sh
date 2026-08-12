#!/bin/bash

PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
LIB_DIR="$PROJECT_ROOT/lib"
LIB_PATH="$LIB_DIR/libiec61850"
BUILD_DIR="$PROJECT_ROOT/build"

echo "=== 4. Очистка старых сборок ==="

# Очистка исходников библиотеки libiec61850
if [ -d "$LIB_PATH" ]; then
    echo "Очистка объектных файлов libiec61850..."
    cd "$LIB_PATH" && make clean >/dev/null 2>&1
    echo "✅ libiec61850 очищена."
    cd "$PROJECT_ROOT" || exit 1
fi

# Удаление папки build
if [ -d "$BUILD_DIR" ]; then
    rm -rf "$BUILD_DIR"
    echo "✅ Директория $BUILD_DIR удалена."
fi

# Удаление старой библиотеки модулей
if [ -f "$LIB_DIR/libmyports.a" ]; then
    rm -f "$LIB_DIR/libmyports.a"
    echo "✅ Файл $LIB_DIR/libmyports.a удален."
fi

# Удаление старых сгенерированных файлов модели
if [ -f "$PROJECT_ROOT/src/static_model.c" ]; then
    rm -f "$PROJECT_ROOT/src/static_model.c"
    echo "✅ Файл $PROJECT_ROOT/src/static_model.c удален."
fi

if [ -f "$PROJECT_ROOT/src/static_model.h" ]; then
    rm -f "$PROJECT_ROOT/src/static_model.h"
    echo "✅ Файл $PROJECT_ROOT/src/static_model.h удален."
fi

echo "=== Очистка успешно завершена ==="