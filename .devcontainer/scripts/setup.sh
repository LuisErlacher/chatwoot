#!/bin/bash

# Configurar rbenv se estiver disponível
if [ -d "$HOME/.rbenv" ]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi

cp .env.example .env
sed -i -e '/REDIS_URL/ s/=.*/=redis:\/\/localhost:6379/' .env
sed -i -e '/POSTGRES_HOST/ s/=.*/=localhost/' .env
sed -i -e '/SMTP_ADDRESS/ s/=.*/=localhost/' .env

# Configuração específica para GitHub Codespaces
if [ -n "$CODESPACE_NAME" ]; then
  sed -i -e "/FRONTEND_URL/ s/=.*/=https:\/\/$CODESPACE_NAME-3000.githubpreview.dev/" .env
  sed -i -e "/WEBPACKER_DEV_SERVER_PUBLIC/ s/=.*/=https:\/\/$CODESPACE_NAME-3035.githubpreview.dev/" .env
  # uncomment the webpacker env variable
  sed -i -e '/WEBPACKER_DEV_SERVER_PUBLIC/s/^# //' .env
  
  # codespaces make the ports public
  gh codespace ports visibility 3000:public 3035:public 8025:public -c "$CODESPACE_NAME"
else
  # Configuração para devcontainer local
  sed -i -e "/FRONTEND_URL/ s/=.*/=http:\/\/localhost:3000/" .env
  sed -i -e "/WEBPACKER_DEV_SERVER_PUBLIC/ s/=.*/=http:\/\/localhost:3035/" .env
  # uncomment the webpacker env variable
  sed -i -e '/WEBPACKER_DEV_SERVER_PUBLIC/s/^# //' .env
  echo "Executando em devcontainer local - configuração de portas do GitHub Codespaces ignorada"
fi

# fix the error with webpacker
echo 'export NODE_OPTIONS=--openssl-legacy-provider' >> ~/.zshrc