#!/bin/bash

PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
BUILD_DIR="$PROJECT_ROOT/build"
LIB_DIR="$PROJECT_ROOT/lib"
DOCKER_LIB_DIR="$PROJECT_ROOT/mips_docker/lib"

echo "=== 4. Очистка старых сборок ==="

# Очистка исходников klish
if [ -d "$LIB_DIR/klish" ]; then
    echo "Очистка klish..."
    (cd "$LIB_DIR/klish" && make distclean >/dev/null 2>&1) || true
    echo "✅ klish очищен."
fi

# Очистка исходников faux
if [ -d "$LIB_DIR/faux" ]; then
    echo "Очистка faux..."
    (cd "$LIB_DIR/faux" && make distclean >/dev/null 2>&1) || true
    echo "✅ faux очищен."
fi

# Удаление папки build
if [ -d "$BUILD_DIR" ]; then
    rm -rf "$BUILD_DIR"
    echo "✅ Директория $BUILD_DIR удалена."
fi

# Очистка собранных библиотек в Docker
if [ -d "$DOCKER_LIB_DIR" ]; then
    rm -rf "$DOCKER_LIB_DIR"/*
    echo "✅ Папка $DOCKER_LIB_DIR очищена."
fi

echo "=== Очистка успешно завершена ==="