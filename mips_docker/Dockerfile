FROM ubuntu:24.04

RUN apt-get update && apt-get install -y --no-install-recommends \
    qemu-user-static \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY romfs.tar.gz .
RUN mkdir -p /app/romfs && tar xf romfs.tar.gz -C /app/romfs && rm romfs.tar.gz

# Копируем системные библиотеки uClibc для QEMU в /app/romfs/lib/
COPY sys_lib/ /app/romfs/lib/

# Cоздаем директорию для приложения Nuitka и копируем ВСЮ папку .dist
RUN mkdir -p /app/romfs/opt/cli_app
COPY nuitka_build/cli.dist/ /app/romfs/opt/cli_app/

# Делаем исполняемым тот cli.bin, который скопировался вместе с папкой .dist
RUN chmod +x /app/romfs/opt/cli_app/cli.bin

USER root

CMD ["qemu-mips-static","-strace" ,"-cpu", "24Kf", "-E", "PYTHONMALLOC=malloc", "-L", "/app/romfs", "/app/romfs/opt/cli_app/cli.bin"]