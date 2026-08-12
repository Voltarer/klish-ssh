#!/bin/bash

set -e

echo "Запуск подготовки окружения Klish MIPS:"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

chmod +x "$SCRIPT_DIR"/*.sh

"$SCRIPT_DIR/scripts/install_deps.sh"
"$SCRIPT_DIR/scripts/create_folders.sh"
"$SCRIPT_DIR/scripts/download_libs.sh"
"$SCRIPT_DIR/scripts/clean.sh"
"$SCRIPT_DIR/scripts/generate_model.sh"

echo "✅ Подготовка успешно завершена! Можно запускать сборку mips.sh."