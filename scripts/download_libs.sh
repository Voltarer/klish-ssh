#!/bin/bash

PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
WORKSPACE_ROOT="$(cd "$PROJECT_ROOT/.." && pwd)"
LIB_DIR="$PROJECT_ROOT/lib"
LIB_PATH="$LIB_DIR/libiec61850"
REALTEK_DIR="$LIB_DIR/realtek"
LIB_TOOLCHAIN="$WORKSPACE_ROOT/toolchain"

echo "=== 3. Загрузка библиотек ==="

if [ ! -d "$LIB_PATH" ]; then
    echo "Библиотека libiec61850 не найдена. Начинаем загрузку..."
    cd "$LIB_DIR" || exit 1
    
    git clone https://github.com/mz-automation/libiec61850.git
    
    if [ $? -eq 0 ]; then
        echo "✅ Библиотека libiec61850 успешно загружена в $LIB_PATH."
    else
        echo "❌ ОШИБКА загрузки библиотеки libiec61850."
        exit 1
    fi
    cd "$PROJECT_ROOT" || exit 1
else
    echo "✅ Библиотека libiec61850 уже присутствует по пути: $LIB_PATH"
fi


echo "=== Загрузка библиотек Realtek ==="

# URL для скачивания файлов из релиза tools
RT_BASE_URL="https://github.com/Voltarer/mms_server_linux/releases/download/tools"
RT_FILES=("librtcore.a" "librtk.a" "librtnic.a" "librtusr.a")

for file in "${RT_FILES[@]}"; do
    if [ ! -f "$REALTEK_DIR/$file" ]; then
        echo "Скачивание $file..."
        if command -v wget &>/dev/null; then
            wget -q -O "$REALTEK_DIR/$file" "$RT_BASE_URL/$file"
        elif command -v curl &>/dev/null; then
            curl -s -L -o "$REALTEK_DIR/$file" "$RT_BASE_URL/$file"
        else
            echo "❌ ОШИБКА: Не найдены ни wget, ни curl для скачивания."
            exit 1
        fi
        
        if [ $? -eq 0 ]; then
            echo "✅ $file успешно скачан."
        else
            echo "❌ ОШИБКА: Не удалось скачать $file."
            exit 1
        fi
    else
        echo "✅ $file уже существует в $REALTEK_DIR."
    fi
done


echo "=== Загрузка и распаковка Toolchain (MIPS) ==="

# URL для скачивания архива тулчейна из релиза docker
TC_BASE_URL="https://github.com/Voltarer/mms_server_linux/releases/download/docker"
TC_ARCHIVE="mips-buildroot-linux-uclibc_sdk-buildroot.tar.xz"
TC_EXTRACTED_DIR="$LIB_TOOLCHAIN/mips-buildroot-linux-uclibc_sdk-buildroot"

# Проверяем, распакован ли уже тулчейн
if [ ! -d "$TC_EXTRACTED_DIR" ]; then
    echo "Тулчейн не найден. Скачивание $TC_ARCHIVE..."
    
    if command -v wget &>/dev/null; then
        wget -q -O "$LIB_TOOLCHAIN/$TC_ARCHIVE" "$TC_BASE_URL/$TC_ARCHIVE"
    elif command -v curl &>/dev/null; then
        curl -s -L -o "$LIB_TOOLCHAIN/$TC_ARCHIVE" "$TC_BASE_URL/$TC_ARCHIVE"
    fi

    # Проверяем, скачался ли архив
    if [ $? -eq 0 ] && [ -f "$LIB_TOOLCHAIN/$TC_ARCHIVE" ]; then
        echo "✅ Архив скачан. Распаковка..."
        # Распаковываем архив прямо в папку toolchain
        tar -xf "$LIB_TOOLCHAIN/$TC_ARCHIVE" -C "$LIB_TOOLCHAIN"
        
        if [ $? -eq 0 ]; then
            echo "✅ Тулчейн успешно распакован в $LIB_TOOLCHAIN."
            # Удаляем архив после успешной распаковки
            rm -f "$LIB_TOOLCHAIN/$TC_ARCHIVE"
        else
            echo "❌ ОШИБКА: Не удалось распаковать архив $TC_ARCHIVE."
            exit 1
        fi
    else
        echo "❌ ОШИБКА: Не удалось скачать $TC_ARCHIVE."
        exit 1
    fi
else
    echo "✅ Тулчейн уже установлен и распакован в $TC_EXTRACTED_DIR."
fi
