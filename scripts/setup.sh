echo "Процесс запущен:"

chmod +x ./scripts/install_deps.sh
chmod +x ./scripts/create_folders.sh
chmod +x ./scripts/download_libs.sh
chmod +x ./scripts/clean.sh
chmod +x ./scripts/generate_model.sh

./scripts/install_deps.sh

./scripts/create_folders.sh

./scripts/download_libs.sh

./scripts/clean.sh

./scripts/generate_model.sh
