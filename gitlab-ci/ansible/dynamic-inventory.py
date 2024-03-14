#!/usr/bin/env python3

import subprocess
import re
import json

# Получаем список инстансов из Yandex.Cloud
output = subprocess.check_output("yc compute instance list", shell=True).decode()

# Создаем пустой словарь для хранения информации об инстансах
inventory = {}

# Регулярное выражение для поиска информации об инстансах
pattern = re.compile(r"Имя: (S+), IP-адрес: (d{1,3}\.d{1,3}\.d{1,3}\.d{1,3}), Вспомогательный IP: (d{1,3}\.d{1,3}\.d{1,3}\.d{1,3})")

# Поиск информации об инстансах и добавление в структуру inventory
for line in output.split('n'):
    match = pattern.search(line)
    if match:
        hostname = match.group(1)
        ip_address = match.group(2)
        inventory[hostname] = {"ip": ip_address}

# Выводим итоговую структуру inventory в JSON формате
print(json.dumps(inventory, indent=4))
