#!/bin/bash
set -e

TOOLCHAIN="$HOME/Documents/ssh/toolchain/mips-buildroot-linux-uclibc_sdk-buildroot"
export SYSROOT="$TOOLCHAIN/mips-buildroot-linux-uclibc/sysroot"
WRAPPER_DIR="$HOME/Documents/ssh/mips_docker/gcc_wrapper"

export PATH="$WRAPPER_DIR:$TOOLCHAIN/bin:$PATH"
export CC="$WRAPPER_DIR/mips-linux-gcc"
export CXX="$WRAPPER_DIR/mips-linux-g++"

export CFLAGS="--sysroot=$SYSROOT -I$SYSROOT/usr/include/python3.11"
export LDFLAGS="--sysroot=$SYSROOT -L$SYSROOT/usr/lib -lpython3.11"

# --- ДОБАВЛЕНЫ ФЛАГИ ОТКЛЮЧЕНИЯ PIE ---
export CFLAGS="--sysroot=$SYSROOT -I$SYSROOT/usr/include/python3.11 -fno-pie -fno-PIE"
export LDFLAGS="--sysroot=$SYSROOT -L$SYSROOT/usr/lib -lpython3.11 -no-pie"

./venv311/bin/python3 -m nuitka \
    --static-libpython=yes\
    --standalone \
    --remove-output \
    --output-dir=nuitka_build \
    cli.py