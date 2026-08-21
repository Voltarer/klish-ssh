#!/bin/bash
set -e # Останавливать скрипт при ошибках

PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
KLISH_DIR="$PROJECT_ROOT/lib/klish"

LIB_TOOLCHAIN="$PROJECT_ROOT/toolchain"
TOOLCHAIN_BIN="$LIB_TOOLCHAIN/mips-buildroot-linux-uclibc_sdk-buildroot/bin"
SYSROOT="$LIB_TOOLCHAIN/mips-buildroot-linux-uclibc_sdk-buildroot/mips-buildroot-linux-uclibc/sysroot"

export PATH="$TOOLCHAIN_BIN:$PATH"
export SYSROOT="$SYSROOT"

echo "========================================================="
echo " СБОРКА CLISH "
echo "========================================================="

cd "$KLISH_DIR"

# Очистка от старых сборок
make distclean >/dev/null 2>&1 || true
rm -f bin/clish bin/.libs/clish

if [ ! -f "configure" ]; then
    ./autogen.sh >/dev/null 2>&1
fi

# Собираем с жестко зашитым путем к библиотекам (RPATH)
./configure --host=mips-linux \
    CC="mips-linux-gcc --sysroot=$SYSROOT" \
    LDFLAGS="-Wl,-rpath=/opt/klish/lib" \
    --without-libxml2 \
    --prefix=/usr

PATH=$PATH make -j$(nproc)

echo "---------------------------------------------------------"
echo "Копирование бинарника и библиотек для релиза"
echo "---------------------------------------------------------"

# Создаем папки для экспорта
mkdir -p "$PROJECT_ROOT/mips_docker"
mkdir -p "$PROJECT_ROOT/mips_docker/opt_klish_lib"
mkdir -p "$PROJECT_ROOT/mips_docker/sys_lib" 

# Копируем системные библиотеки uClibc для Docker/QEMU
cp -aL "$SYSROOT/lib/"* "$PROJECT_ROOT/mips_docker/sys_lib/" 

# Копируем бинарник clish
if [ -f "bin/.libs/clish" ]; then
    cp "bin/.libs/clish" "$PROJECT_ROOT/mips_docker/clish"
elif [ -f "bin/clish" ]; then
    cp "bin/clish" "$PROJECT_ROOT/mips_docker/clish"
else
    find . -type f -executable -name "clish" | head -n 1 | xargs -I {} cp {} "$PROJECT_ROOT/mips_docker/clish"
fi

# Копируем собранные плагины и библиотеки Klish в папку opt_klish_lib/
find . -name "*.so*" -exec cp -a {} "$PROJECT_ROOT/mips_docker/opt_klish_lib/" \;

echo "✅ УСПЕХ! Бинарник скопирован в mips_docker/, а библиотеки — в mips_docker/opt_klish_lib/"
file "$PROJECT_ROOT/mips_docker/clish"