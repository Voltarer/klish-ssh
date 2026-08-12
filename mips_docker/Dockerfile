FROM ubuntu:24.04

RUN apt-get update && apt-get install -y --no-install-recommends \
    qemu-user-static \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Распаковываем базовую ФС
COPY romfs.tar.gz .
RUN mkdir -p /app/romfs && tar xf romfs.tar.gz -C /app/romfs && rm romfs.tar.gz

# Возвращаем системные библиотеки uClibc для работы динамического загрузчика
COPY lib/ /app/romfs/lib/
COPY lib/ /lib/

# Копируем бинарник clish
COPY clish /app/romfs/usr/bin/clish
RUN chmod +x /app/romfs/usr/bin/clish

# Копируем XML-конфигурации оболочки
RUN mkdir -p /app/romfs/etc/clish
COPY clish_xml/ /app/romfs/etc/clish/

# скрипт-заглушка для системных команд
RUN mkdir -p /app/romfs/sbin /app/romfs/usr/sbin /app/romfs/bin && \
    echo '#!/bin/sh' > /app/romfs/sbin/reboot && \
    echo 'echo "[ЭМУЛЯТОР] Команда reboot перехвачена заглушкой. Выход из Klish..."' >> /app/romfs/sbin/reboot && \
    echo 'kill -TERM $PPID' >> /app/romfs/sbin/reboot && \
    chmod +x /app/romfs/sbin/reboot && \
    ln -sf /app/romfs/sbin/reboot /app/romfs/usr/sbin/reboot && \
    ln -sf /app/romfs/sbin/reboot /app/romfs/bin/reboot

USER root

CMD ["qemu-mips-static", "-L", "/app/romfs", "-E", "LD_LIBRARY_PATH=/lib:/app/romfs/lib", "-E", "CLISH_PATH=/etc/clish", "/app/romfs/usr/bin/clish"]