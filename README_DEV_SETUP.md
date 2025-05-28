# AutomatizaSE - Manual de Setup de Desenvolvimento 🚀

Este manual fornece instruções completas para configurar o ambiente de desenvolvimento do AutomatizaSE em uma nova máquina.

## 📋 Pré-requisitos

### Sistema Operacional Suportado
- **Linux** (Ubuntu/Debian recomendado)
- **macOS** 
- **Windows** (via WSL2)

### Ferramentas Base Necessárias
- Git
- Docker & Docker Compose
- curl/wget

---

## 🛠️ Instalação das Dependências

### 1. Git
```bash
# Ubuntu/Debian
sudo apt update && sudo apt install git

# macOS (via Homebrew)
brew install git

# Configure sua identidade
git config --global user.name "Seu Nome"
git config --global user.email "seu.email@exemplo.com"
```

### 2. Docker & Docker Compose
```bash
# Ubuntu/Debian - Docker oficial
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Instalar Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# macOS (via Homebrew)
brew install docker docker-compose
```

> ⚠️ **Importante**: Faça logout/login após adicionar usuário ao grupo docker

### 3. Ruby 3.3.3 (rbenv recomendado)
```bash
# Instalar rbenv
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash

# Adicionar ao seu shell profile (~/.bashrc, ~/.zshrc)
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
source ~/.bashrc

# Instalar Ruby 3.3.3
rbenv install 3.3.3
rbenv global 3.3.3

# Verificar instalação
ruby -v  # deve retornar 3.3.3
```

### 4. Node.js 23.7.0 & PNPM (nvm recomendado)
```bash
# Instalar nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
source ~/.bashrc

# Instalar Node.js 23.7.0
nvm install 23.7.0
nvm use 23.7.0
nvm alias default 23.7.0

# Instalar PNPM
npm install -g pnpm@10.2.0

# Verificar instalações
node -v  # deve retornar v23.7.0
pnpm -v  # deve retornar 10.2.0
```

### 5. PostgreSQL 16 (com pgvector)
```bash
# Ubuntu/Debian
sudo apt install postgresql-16 postgresql-contrib-16 postgresql-16-pgvector libpq-dev

# macOS (via Homebrew)
brew install postgresql@16 pgvector

# Iniciar serviço
sudo systemctl start postgresql    # Linux
brew services start postgresql@16  # macOS

# Configurar usuário postgres
sudo -u postgres psql
\password postgres  # definir senha: chatwoot_dev
\q

# Criar usuário para desenvolvimento
sudo -u postgres createuser -s $USER
```

### 6. Redis
```bash
# Ubuntu/Debian
sudo apt install redis-server

# macOS (via Homebrew)
brew install redis

# Iniciar serviço
sudo systemctl start redis-server    # Linux
brew services start redis            # macOS

# Testar conexão
redis-cli ping  # deve retornar PONG
```

---

## 📦 Configuração do Projeto

### 1. Clone do Repositório
```bash
# Clone o repositório AutomatizaSE
git clone git@github.com:LuisErlacher/chatwoot.git automatizase
cd automatizase

# Verificar branch atual
git branch  # deve estar em feature/desbloqueio-enterprise ou main
```

### 2. Configuração de Variáveis de Ambiente
```bash
# Copiar arquivo de exemplo
cp env.example .env

# Editar com suas configurações
nano .env  # ou seu editor preferido
```

**Configuração mínima do .env:**
```bash
# Database
DATABASE_URL=postgresql://postgres:chatwoot_dev@localhost/chatwoot_dev
POSTGRES_DATABASE=chatwoot_dev
POSTGRES_USERNAME=postgres
POSTGRES_PASSWORD=chatwoot_dev

# Redis
REDIS_URL=redis://localhost:6379

# Rails
SECRET_KEY_BASE=$(openssl rand -hex 64)
RAILS_ENV=development

# Frontend
FRONTEND_URL=http://localhost:3000

# AutomatizaSE específico
AUTOMATIZASE_ENABLED=true
AUTOMATIZASE_API_ENDPOINT=https://api-dev.automatizase.com
AUTOMATIZASE_PREMIUM_FEATURES=true

# Stripe (desenvolvimento)
STRIPE_PUBLISHABLE_KEY=pk_test_your_key_here
STRIPE_SECRET_KEY=sk_test_your_key_here
STRIPE_WEBHOOK_SECRET=whsec_your_webhook_secret
```

> 📋 **Referência completa**: Consulte `AUTOMATIZASE_ENV_VARIABLES.md` para todas as variáveis disponíveis.

### 3. Instalação de Dependências Ruby
```bash
# Instalar Bundler
gem install bundler

# Instalar gems do projeto
bundle install
```

### 4. Instalação de Dependências Node.js
```bash
# Verificar versão do Node.js
node -v  # deve ser 23.7.0

# Instalar dependências
pnpm install
```

### 5. Configuração do Banco de Dados
```bash
# Criar bancos de dados
rails db:create

# Executar migrações
rails db:migrate

# Popular com dados iniciais
rails db:seed
```

**Credenciais criadas após seed:**
- **Admin**: john@acme.inc / Password1!
- **URL**: http://localhost:3000

### 6. Compilação de Assets Frontend
```bash
# Compilar assets em desenvolvimento
bin/vite dev &

# Ou rodar o build uma vez
bin/vite build
```

---

## 🚀 Executando o Projeto

### Opção 1: Execução Nativa (Recomendado para desenvolvimento)
```bash
# Terminal 1: Servidor Rails
rails server

# Terminal 2: Servidor Vite (assets)
bin/vite dev

# Terminal 3: Worker Sidekiq (jobs em background)
bundle exec sidekiq

# Terminal 4: MailHog (emails de desenvolvimento)
# Instalar: go install github.com/mailhog/MailHog@latest
~/go/bin/MailHog
```

### Opção 2: Docker Compose (Alternativa)
```bash
# Construir containers
docker-compose build

# Executar serviços
docker-compose up

# Executar migrações no container
docker-compose exec rails rails db:create db:migrate db:seed
```

---

## 🔧 Ferramentas de Desenvolvimento

### Configuração de Qualidade de Código

**RuboCop (Ruby):**
```bash
# Verificar código Ruby
bundle exec rubocop

# Corrigir automaticamente
bundle exec rubocop -a
```

**ESLint (JavaScript/Vue):**
```bash
# Verificar código JS/Vue
./node_modules/.bin/eslint app/**/*.{js,vue}

# Corrigir automaticamente
./node_modules/.bin/eslint app/**/*.{js,vue} --fix
```

**Prettier (Formatação):**
```bash
# Formatar código
npx prettier --write "app/**/*.{js,vue,scss}"
```

### Pre-commit Hooks
Os hooks estão configurados automaticamente via Husky:
```bash
# Verificar configuração
cat .husky/pre-commit

# Testar hooks manualmente
npx lint-staged
```

### Testes
```bash
# Testes Ruby (RSpec)
bundle exec rspec

# Testes JavaScript (Vitest)
pnpm test

# Executar com coverage
pnpm test:coverage
```

---

## 🌐 Acessos após Setup

| Serviço | URL | Credenciais |
|---------|-----|-------------|
| **AutomatizaSE App** | http://localhost:3000 | john@acme.inc / Password1! |
| **MailHog** | http://localhost:8025 | Não requer login |
| **PostgreSQL** | localhost:5432 | postgres / chatwoot_dev |
| **Redis** | localhost:6379 | Sem senha |

---

## 🔍 Verificação da Instalação

Execute este checklist para verificar se tudo está funcionando:

```bash
# ✅ 1. Verificar versões
ruby -v        # 3.3.3
node -v        # v23.7.0
pnpm -v        # 10.2.0
psql --version # 16.x
redis-cli --version

# ✅ 2. Verificar banco de dados
rails db:version

# ✅ 3. Verificar aplicação
curl http://localhost:3000/api/v1/accounts/1/profile

# ✅ 4. Verificar assets compilando
ls public/vite/assets/

# ✅ 5. Verificar jobs em background
redis-cli ping
bundle exec sidekiq --version
```

---

## 🐛 Solução de Problemas Comuns

### Erro: "Bundler: command not found"
```bash
gem install bundler
rbenv rehash
```

### Erro: "PostgreSQL connection failed"
```bash
sudo systemctl start postgresql
sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'chatwoot_dev';"
```

### Erro: "Redis connection refused"
```bash
sudo systemctl start redis-server
redis-cli ping
```

### Erro: "Node.js version incompatible"
```bash
nvm use 23.7.0
# ou instalar: nvm install 23.7.0
```

### Erro: "PG::UndefinedObject: ERROR: extension "pgvector" does not exist"
```bash
# Ubuntu/Debian
sudo apt install postgresql-16-pgvector
sudo systemctl restart postgresql

# macOS
brew install pgvector
brew services restart postgresql@16
```

### Assets não carregando
```bash
# Limpar cache e recompilar
rm -rf public/vite/assets/*
rm -rf tmp/cache/*
bin/vite build
```

---

## 📚 Recursos Adicionais

- **Documentação Original**: [chatwoot.com/help-center](https://www.chatwoot.com/help-center)
- **Git Workflow**: `WORKFLOW_GIT.md`
- **Variáveis de Ambiente**: `AUTOMATIZASE_ENV_VARIABLES.md`
- **Tasks do Projeto**: `tasks/tasks.json`

---

## 🆘 Suporte

Se encontrar problemas durante o setup:

1. **Verifique os logs**: `tail -f log/development.log`
2. **Consulte issues conhecidos**: GitHub Issues do projeto
3. **Execute diagnóstico**: `rails runner "puts Rails.env"`
4. **Verifique configurações**: `rails console` → `ENV['DATABASE_URL']`

---

**✨ Setup concluído com sucesso!** 

Agora você tem o AutomatizaSE funcionando localmente e está pronto para desenvolver novas funcionalidades. 