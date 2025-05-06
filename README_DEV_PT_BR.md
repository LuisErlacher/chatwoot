# Tutorial de Desenvolvimento do Chatwoot

Este guia explica como configurar e iniciar o ambiente de desenvolvimento do Chatwoot para visualização e edição do sistema.

## Pré-requisitos

- Git
- Docker e Docker Compose
- Node.js (versão recomendada no arquivo .nvmrc)
- Ruby (versão especificada no arquivo .ruby-version)
- PostgreSQL (caso não use Docker)
- Redis (caso não use Docker)
- Visual Studio Code (recomendado)

## Opções de Ambiente de Desenvolvimento

### 1. Usando Docker Compose (Recomendado)

Esta é a maneira mais simples de começar, pois configura automaticamente todos os serviços necessários:

```bash
# Clone o repositório
git clone https://github.com/chatwoot/chatwoot.git
cd chatwoot

# Copie o arquivo de ambiente de exemplo
cp .env.example .env

# Inicie os contêineres
docker-compose up
```

Após a inicialização:
- Aplicação Rails: http://localhost:3000
- Servidor Vite: http://localhost:3036
- Interface Mailhog: http://localhost:8025

Para acessar o shell dentro do contêiner:
```bash
docker-compose exec rails bash
```

### 2. Usando VS Code com Dev Containers

O Chatwoot inclui configuração para desenvolvimento com [VS Code Remote Containers](https://code.visualstudio.com/docs/remote/containers):

1. Instale a extensão [Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) no VS Code
2. Clone o repositório e abra-o no VS Code
3. Clique em "Reopen in Container" quando solicitado ou use o comando no VS Code
4. O VS Code configurará automaticamente o ambiente de desenvolvimento

Esta opção já inclui todas as extensões recomendadas e configurações para desenvolvimento.

### 3. GitHub Codespaces

Para desenvolvimento no navegador:

1. Acesse o repositório no GitHub
2. Clique no botão "Code"
3. Selecione a aba "Codespaces"
4. Clique em "Create codespace on master"

O GitHub criará um ambiente de desenvolvimento completo no navegador.

### 4. Execução Local Direta

Para executar diretamente na sua máquina:

```bash
# Clone o repositório
git clone https://github.com/chatwoot/chatwoot.git
cd chatwoot

# Instale as dependências
bundle install
yarn install

# Configure o banco de dados
cp config/database.yml.example config/database.yml
# Edite database.yml com suas configurações locais

# Prepare o banco de dados
bundle exec rails db:create db:migrate db:seed

# Inicie os serviços (requer Foreman ou Overmind)
foreman start -f Procfile.dev
# ou
overmind start -f Procfile.dev
```

## Estrutura do Projeto

- `app/` - Código principal do Rails
  - `controllers/` - Controladores
  - `models/` - Modelos
  - `views/` - Visualizações
  - `javascript/` - Código JavaScript/Vue.js
  - `assets/` - Arquivos estáticos
- `config/` - Configuração do Rails
- `db/` - Migrações de banco de dados
- `lib/` - Bibliotecas adicionais
- `enterprise/` - Código dos recursos enterprise

## Ativando Recursos Enterprise

Para ativar recursos enterprise durante o desenvolvimento, siga as instruções no arquivo `README_enterprise.md`.

## Acessando o Sistema Admin

Após iniciar o projeto, você pode acessar o sistema com as credenciais padrão:

- URL: http://localhost:3000
- Email: john@acme.inc
- Senha: 123456

## Dicas de Desenvolvimento

1. **Atualizações de Código**: O servidor Vite facilita o hot-reload para alterações no frontend.

2. **Console Rails**: Para acessar o console Rails:
   ```bash
   # Com Docker
   docker-compose exec rails rails c
   
   # Sem Docker
   bundle exec rails c
   ```

3. **Logs**: Visualize os logs para depuração:
   ```bash
   # Com Docker
   docker-compose logs -f rails
   
   # Sem Docker
   tail -f log/development.log
   ```

4. **Reset do Banco de Dados**: Se necessário:
   ```bash
   # Com Docker
   docker-compose exec rails rails db:reset
   
   # Sem Docker
   bundle exec rails db:reset
   ```

## Solução de Problemas

- **Problema com portas**: Verifique se as portas 3000, 3036, 5432, 6379 e 8025 estão disponíveis.
- **Problemas de DB**: Verifique as configurações em `config/database.yml`.
- **Erros de JavaScript**: Verifique os logs do Vite no console.
- **Problemas de Docker**: Execute `docker-compose down -v` e tente novamente.

## Recursos Adicionais

- [Documentação do Chatwoot](https://www.chatwoot.com/docs)
- [API do Chatwoot](https://www.chatwoot.com/developers/api)
- [Discord da Comunidade](https://discord.gg/cJXdrwS) 