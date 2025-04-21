#!/bin/bash

echo -e "Устанавливаем nodejs и всё необходимое"
sudo apt-get update
source ~/.bashrc
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
source ~/.bashrc
nvm install v22.11.0

sudo apt-get update
sudo apt-get install postfix zip
npm install axios js-base64 fs path

sudo mkdir /root/github_update && cd /root/github_update
curl -fsSL https://github.com/AndriiKok/Activity/raw/main/ext/files.zip > "/root/github_update/files.zip"
unzip -q -d /root/github_update files.zip && rm -rf /root/github_update/files.zip
echo -e "Готово, продолжайте по гайду"
