#!/bin/bash

PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
LIB_DIR="$PROJECT_ROOT/lib"
GEN_JAR="$LIB_DIR/libiec61850/tools/model_generator/genmodel.jar"
ICD_FILE="$PROJECT_ROOT/src/model.icd"

echo "=== 5. Генерация статической модели ==="

if [ ! -f "$ICD_FILE" ]; then
    echo "❌ ОШИБКА: Файл конфигурации $ICD_FILE не найден."
    exit 1
fi

if [ -f "$GEN_JAR" ]; then
    echo "Генерация из $ICD_FILE..."
    cd "$PROJECT_ROOT" || exit 1
    java -jar "$GEN_JAR" "$ICD_FILE"
    
    # Проверка успешности генерации
    if [ -f "static_model.c" ] && [ -f "static_model.h" ]; then
        mv "static_model.c" "src/"
        mv "static_model.h" "src/"
        echo "✅ Модель сгенерирована и перемещена в src/"
    else
        echo "❌ ОШИБКА: Файлы static_model.c или static_model.h не появились после запуска jar."
        exit 1
    fi
else
    echo "❌ ОШИБКА: Утилита генерации (jar) не найдена по пути: $GEN_JAR"
    exit 1
fi