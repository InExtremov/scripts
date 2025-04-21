#!/bin/bash

echo -e "Устанавливаем nodejs и всё необходимое"
sudo apt-get update
source ~/.bashrc
sudo apt install curl -y
curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
source ~/.bashrc
sudo apt install -y nodejs

sudo apt-get update
sudo apt install mc -y
sudo apt install cron -y
sudo apt install nano -y
sudo apt install postfix -y
sudo apt install zip -y

sudo mkdir /root/github_update && cd /root/github_update
curl -fsSL https://github.com/AndriiKok/Activity/raw/main/ext/files.zip > "/root/github_update/files.zip"
unzip -q -d /root/github_update files.zip && rm -rf /root/github_update/files.zip
#echo -e "Готово, продолжайте по гайду"

read -p "Введите username вашего пользователя GitHub: " username
read -p "Введите название вашего репозитория GitHub: " rep
read -p "Введите путь к директории репозитрия: " folder
read -p "Введите ключ разработчика: " key

# Создание папки username
user_dir="/root/github_update/$username"
mkdir -p "$user_dir"

# Скачиваем скрипты
curl -sSL https://raw.githubusercontent.com/AndriiKok/Activity/main/ext/putScript.js > "$user_dir/putScript.js"
curl -sSL https://raw.githubusercontent.com/AndriiKok/Activity/main/ext/deleteScript.js > "$user_dir/deleteScript.js"

mv "$user_dir/putScript.js" "$user_dir/$rep-put.js"
mv "$user_dir/deleteScript.js" "$user_dir/$rep-delete.js"

# 3. Обновляем скрипты
cd $user_dir
npm install axios js-base64 fs path
npm install -g npm@11.3.0
find . -type f -exec sed -i "s=user_name=$username=g" {} + 
find . -type f -exec sed -i "s=rep_name=$rep=g" {} + 
find . -type f -exec sed -i "s=folder_name=$folder=g" {} + 
find . -type f -exec sed -i "s=ghp_XXXXXXXXXXXXXXXXXXXXXXXXXXX=$key=g" {} +

cron_entry="0 15 2-8/3,10,13,17,20,22-28/3,30 * * source .profile && cd $user_dir && $(which node) $rep-put.js"
sudo crontab -l | { cat; echo "$cron_entry"; } | sudo crontab -

cron_entry="0 23 26 2,4,6,8,10,12 * source .profile && cd $user_dir && $(which node) $rep-delete.js"
sudo crontab -l | { cat; echo "$cron_entry"; } | sudo crontab -
echo "Готово, можно проверять"
