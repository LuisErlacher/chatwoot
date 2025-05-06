#!/bin/bash

# Define a função para criar o banco de dados chatwoot
create_chatwoot_db() {
  # Configurar variáveis de ambiente PGPASSWORD se POSTGRES_PASSWORD estiver definido
  if [ ! -z "$POSTGRES_PASSWORD" ]; then
    export PGPASSWORD=$POSTGRES_PASSWORD
  fi

  echo "Checking if chatwoot database exists..."
  
  # Verificar se o banco de dados chatwoot já existe
  if ! psql -h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USERNAME -lqt | cut -d \| -f 1 | grep -qw chatwoot; then
    echo "Creating chatwoot database..."
    
    # Criar banco de dados
    psql -h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USERNAME -c "CREATE DATABASE chatwoot;"
    
    # Verificar se a criação foi bem-sucedida
    if [ $? -eq 0 ]; then
      echo "Database chatwoot created successfully."
    else
      echo "Failed to create database chatwoot."
      return 1
    fi
  else
    echo "Database chatwoot already exists."
  fi
  
  # Limpar a variável PGPASSWORD por segurança
  if [ ! -z "$POSTGRES_PASSWORD" ]; then
    unset PGPASSWORD
  fi
  
  return 0
}

# Executar a função
create_chatwoot_db 