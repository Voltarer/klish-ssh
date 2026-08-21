#!/usr/bin/env python3
import cmd
import os
import subprocess

class MipsCLI(cmd.Cmd):
    prompt = 'mips-device> '
    intro = "==========================================\n Welcome to MIPS Embedded Linux CLI\n Type '?' for help or 'exit' to quit.\n=========================================="

    def do_show(self, arg):
        """Команды просмотра: show version"""
        if arg == 'version':
            print("OS: Embedded Linux (MIPS architecture)")
            subprocess.run(["uname", "-r"])
        else:
            print("Неизвестная подкоманда. Используйте: show version")

    def complete_show(self, text, line, begidx, endidx):
        return [i for i in ['version'] if i.startswith(text)]

    def do_reboot(self, arg):
        """Перезагрузка устройства"""
        print("System is going down for reboot...")
        subprocess.run(["/sbin/reboot"])

    def do_exit(self, arg):
        """Выход из CLI"""
        return True

if __name__ == '__main__':
    MipsCLI().cmdloop()