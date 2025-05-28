#!/bin/bash

# Script para limpar configurações do GitHub específicas do Chatwoot
# Execute este script após clonar o projeto para personalizar para AutomatizaSE

echo "🧹 Limpando configurações do GitHub do Chatwoot original..."

# Backup da pasta .github original
if [ -d ".github" ]; then
    echo "📦 Criando backup da configuração original..."
    cp -r .github .github_chatwoot_backup
fi

# Remover workflows que são específicos do Chatwoot
echo "🗑️  Removendo workflows específicos do Chatwoot..."
rm -f .github/workflows/publish_foss_docker.yml
rm -f .github/workflows/publish_ee_docker.yml
rm -f .github/workflows/publish_codespace_image.yml
rm -f .github/workflows/nightly_installer.yml

# Atualizar CODEOWNERS
echo "👥 Atualizando CODEOWNERS..."
cat > .github/CODEOWNERS << 'EOF'
# AutomatizaSE Code Owners
# Substitua pelos usuários/equipes do seu projeto

# Arquivos de configuração enterprise
/enterprise/* @seu-usuario

# Configurações do sistema
/config/* @seu-usuario
/docker/* @seu-usuario

# Arquivos de segurança
/.env.example @seu-usuario
/config/initializers/ @seu-usuario
EOF

# Atualizar FUNDING.yml para o seu projeto
echo "💰 Atualizando informações de financiamento..."
cat > .github/FUNDING.yml << 'EOF'
# Informações de financiamento para AutomatizaSE
# Remova ou atualize conforme necessário

# github: [seu-usuario]
# custom: ["https://seu-site.com/donate"]
EOF

# Criar um novo workflow básico para o projeto
echo "⚙️  Criando workflow básico para AutomatizaSE..."
mkdir -p .github/workflows
cat > .github/workflows/ci.yml << 'EOF'
name: CI AutomatizaSE

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  test:
    runs-on: ubuntu-latest

    services:
      postgres:
        image: postgres:13
        env:
          POSTGRES_PASSWORD: postgres
          POSTGRES_DB: chatwoot_test
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5

    steps:
    - uses: actions/checkout@v4

    - name: Setup Ruby
      uses: ruby/setup-ruby@v1
      with:
        ruby-version: '3.2'
        bundler-cache: true

    - name: Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: '18'
        cache: 'npm'

    - name: Install dependencies
      run: |
        npm install
        bundle install

    - name: Setup database
      env:
        RAILS_ENV: test
        DATABASE_URL: postgres://postgres:postgres@localhost:5432/chatwoot_test
      run: |
        bundle exec rails db:create
        bundle exec rails db:schema:load

    - name: Run tests
      env:
        RAILS_ENV: test
        DATABASE_URL: postgres://postgres:postgres@localhost:5432/chatwoot_test
      run: |
        bundle exec rspec

    - name: Upload coverage to Codecov
      uses: codecov/codecov-action@v3
      with:
        file: ./coverage/.resultset.json
        fail_ci_if_error: false
EOF

# Atualizar Pull Request Template
echo "📝 Atualizando template de Pull Request..."
cat > .github/PULL_REQUEST_TEMPLATE.md << 'EOF'
## Descrição
Descreva brevemente as mudanças feitas neste PR.

## Tipo de mudança
- [ ] Bug fix (mudança que corrige um problema)
- [ ] Nova funcionalidade (mudança que adiciona funcionalidade)
- [ ] Breaking change (correção ou funcionalidade que causaria falha em funcionalidade existente)
- [ ] Melhoria de documentação

## Como testar
Descreva os passos para testar suas mudanças:
1. ...
2. ...

## Checklist
- [ ] Meu código segue as diretrizes do projeto
- [ ] Realizei uma auto-revisão do meu código
- [ ] Comentei meu código, especialmente em áreas difíceis de entender
- [ ] Fiz mudanças correspondentes na documentação
- [ ] Minhas mudanças não geram novos warnings
- [ ] Adicionei testes que provam que minha correção é efetiva ou que minha funcionalidade funciona
- [ ] Testes unitários novos e existentes passam localmente com minhas mudanças

## Screenshots (se aplicável)
Adicione screenshots para ajudar a explicar suas mudanças.

## Contexto adicional
Adicione qualquer outro contexto sobre o pull request aqui.
EOF

echo "✅ Limpeza concluída!"
echo ""
echo "📋 O que foi feito:"
echo "   • Backup criado em .github_chatwoot_backup/"
echo "   • Workflows específicos do Chatwoot removidos"
echo "   • CODEOWNERS atualizado"
echo "   • Novo workflow de CI criado"
echo "   • Templates atualizados"
echo ""
echo "🔧 Próximos passos:"
echo "   1. Edite .github/CODEOWNERS com seus usuários"
echo "   2. Configure secrets necessários no GitHub"
echo "   3. Ajuste o workflow de CI conforme necessário"
echo "   4. Remova o backup quando estiver satisfeito: rm -rf .github_chatwoot_backup/" 