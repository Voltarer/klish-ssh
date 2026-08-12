#!/bin/bash

PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
LIB_DIR="$PROJECT_ROOT/lib"
TOOLCHAIN_DIR="$PROJECT_ROOT/toolchain"

echo "=== 3. Загрузка библиотек и Toolchain ==="

TC_BASE_URL="https://github.com/Voltarer/mms_server_linux/releases/download/docker"
TC_ARCHIVE="mips-buildroot-linux-uclibc_sdk-buildroot.tar.xz"
TC_EXTRACTED_DIR="$TOOLCHAIN_DIR/mips-buildroot-linux-uclibc_sdk-buildroot"

# 1. Проверка и скачивание Toolchain
if [ ! -d "$TC_EXTRACTED_DIR" ]; then
    echo "Тулчейн MIPS не найден. Скачивание $TC_ARCHIVE..."
    
    if command -v wget &>/dev/null; then
        wget -q -O "$TOOLCHAIN_DIR/$TC_ARCHIVE" "$TC_BASE_URL/$TC_ARCHIVE"
    elif command -v curl &>/dev/null; then
        curl -s -L -o "$TOOLCHAIN_DIR/$TC_ARCHIVE" "$TC_BASE_URL/$TC_ARCHIVE"
    fi

    if [ -f "$TOOLCHAIN_DIR/$TC_ARCHIVE" ]; then
        echo "✅ Архив скачан. Распаковка..."
        tar -xf "$TOOLCHAIN_DIR/$TC_ARCHIVE" -C "$TOOLCHAIN_DIR"
        rm -f "$TOOLCHAIN_DIR/$TC_ARCHIVE"
        echo "✅ Тулчейн успешно распакован в $TOOLCHAIN_DIR."
    else
        echo "❌ ОШИБКА: Не удалось скачать $TC_ARCHIVE."
        exit 1
    fi
else
    echo "✅ Тулчейн MIPS уже присутствует в $TC_EXTRACTED_DIR."
fi

# 2. Проверка исходников klish / faux
if [ ! -d "$LIB_DIR/klish" ]; then
    echo "Исходники klish не найдены в lib/klish. Загрузка..."
    git clone https://github.com/serj-kalichev/klish.git "$LIB_DIR/klish" || true
fi

if [ ! -d "$LIB_DIR/faux" ]; then
    echo "Исходники faux не найдены в lib/faux. Загрузка..."
    git clone https://github.com/serj-kalichev/faux.git "$LIB_DIR/faux" || true
fi

echo "=== Загрузка завершена ==="