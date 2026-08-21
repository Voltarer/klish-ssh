#!/bin/bash
set -e

# Явно задаем абсолютный путь без использования $HOME
TOOLCHAIN="/home/npp3726/Documents/ssh/toolchain/mips-buildroot-linux-uclibc_sdk-buildroot"
SYSROOT="$TOOLCHAIN/mips-buildroot-linux-uclibc/sysroot"
export PATH="$TOOLCHAIN/bin:$PATH"

BUILD_DIR="/tmp/cpython_mips_build"

echo "==> Подготовка папки сборки..."
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

echo "==> Скачивание CPython 3.11..."
wget -q --show-progress https://www.python.org/ftp/python/3.11.9/Python-3.11.9.tar.xz
tar -xf Python-3.11.9.tar.xz

echo "==> [1/2] Сборка хостового Python (x86_64)..."
mkdir -p "$BUILD_DIR/host-build"
cd "$BUILD_DIR/host-build"
"$BUILD_DIR/Python-3.11.9/configure" --prefix="$BUILD_DIR/host-python"
make -j$(nproc)
make install
HOST_PYTHON="$BUILD_DIR/host-python/bin/python3.11"

echo "==> [2/2] Кросс-компиляция CPython под MIPS..."
mkdir -p "$BUILD_DIR/mips-build"
cd "$BUILD_DIR/mips-build"

export CC="mips-linux-gcc"
export CXX="mips-linux-g++"
export AR="mips-linux-ar"
export RANLIB="mips-linux-ranlib"
export CFLAGS="--sysroot=$SYSROOT"
export LDFLAGS="--sysroot=$SYSROOT"

# Явно задаем наличие системных устройств для cross-compile
ac_cv_file__dev_ptmx=yes \
ac_cv_file__dev_ptc=no \
"$BUILD_DIR/Python-3.11.9/configure" \
  --host=mips-buildroot-linux-uclibc \
  --build=x86_64-pc-linux-gnu \
  --prefix=/usr \
  --disable-test-modules \
  --without-ensurepip \
  --with-build-python="$HOST_PYTHON"\
  --disable-ipv6

make -j$(nproc)

echo "==> Установка артефактов в SDK..."
make install DESTDIR="$SYSROOT"

echo "==> Очистка..."
cd /tmp
rm -rf "$BUILD_DIR"

echo "==> Проверка:"
if [ -f "$SYSROOT/usr/include/python3.11/Python.h" ]; then
    echo "УСПЕХ: Python.h установлен в SDK!"
else
    echo "ОШИБКА: Файл не найден."
    exit 1
fi