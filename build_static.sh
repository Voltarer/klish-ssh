#!/bin/bash
set -e

PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BUILD_DIR="$PROJECT_ROOT/build"
KLISH_DIR="$PROJECT_ROOT/lib/klish"

LIB_TOOLCHAIN="$PROJECT_ROOT/toolchain"
TOOLCHAIN_BIN="$LIB_TOOLCHAIN/mips-buildroot-linux-uclibc_sdk-buildroot/bin"
SYSROOT="$LIB_TOOLCHAIN/mips-buildroot-linux-uclibc_sdk-buildroot/mips-buildroot-linux-uclibc/sysroot"

export PATH="$TOOLCHAIN_BIN:$PATH"
export SYSROOT="$SYSROOT"

echo "========================================================="
echo " СБОРКА СТАТИЧЕСКОГО CLISH (БЕЗ PIC) ДЛЯ ЖЕЛЕЗА "
echo "========================================================="

cd "$KLISH_DIR"
make distclean >/dev/null 2>&1 || true

if [ ! -f "configure" ]; then
    ./autogen.sh >/dev/null 2>&1
fi

# 1. Этап конфигурации (без libtool-специфичных флагов)
./configure --host=mips-linux \
    CC="mips-linux-gcc --sysroot=$SYSROOT" \
    AR="mips-linux-ar" \
    RANLIB="mips-linux-ranlib" \
    CFLAGS="-I$SYSROOT/usr/include -fno-PIC -fno-pic" \
    LDFLAGS="-static -L$SYSROOT/usr/lib" \
    --enable-static \
    --disable-shared \
    --without-libxml2 \
    --prefix=/usr

# 2. Этап сборки (передаем -all-static напрямую в libtool через make)
PATH=$PATH make LDFLAGS="-all-static -static -L$SYSROOT/usr/lib" -j$(nproc)

mkdir -p "$BUILD_DIR"
cp bin/clish "$BUILD_DIR/clish_mips_static"

echo "---------------------------------------------------------"
echo "РЕЗУЛЬТАТ ПРОВЕРКИ БИНАРНИКА:"
echo "---------------------------------------------------------"
file "$BUILD_DIR/clish_mips_static"