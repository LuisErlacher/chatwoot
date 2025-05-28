# Workflow Git - AutomatizaSE

## Visão Geral

Este documento define o workflow Git para o desenvolvimento do projeto AutomatizaSE, baseado no Chatwoot com customizações específicas para o mercado brasileiro.

## Estrutura de Branches

### Branches Principais

- **`main`**: Branch de produção, contém código estável e testado
- **`develop`**: Branch de desenvolvimento, onde features são integradas
- **`feature/desbloqueio-enterprise`**: Branch atual de trabalho para configurações AutomatizaSE

### Convenção de Nomenclatura

- **Features**: `feature/nome-da-funcionalidade`
  - Exemplo: `feature/stripe-integration`
  - Exemplo: `feature/pt-br-translation`
  - Exemplo: `feature/subscription-plans`

- **Correções**: `fix/nome-do-bug`
  - Exemplo: `fix/stripe-webhook-validation`
  - Exemplo: `fix/translation-missing-keys`

- **Releases**: `release/vX.Y.Z`
  - Exemplo: `release/v1.0.0`

## Processo de Desenvolvimento

### 1. Criando uma Nova Feature

```bash
# A partir da branch develop
git checkout develop
git pull origin develop

# Criar nova branch de feature
git checkout -b feature/nome-da-funcionalidade

# Desenvolver e fazer commits
git add .
git commit -m "feat(escopo): descrição da funcionalidade"

# Push da branch
git push origin feature/nome-da-funcionalidade
```

### 2. Commits

#### Template de Commit
O projeto utiliza um template de commit configurado em `.gitmessage`. Use:

```bash
git commit
```

#### Formato: Conventional Commits
```
tipo(escopo): descrição breve em português

Corpo explicativo (opcional):
- Explique o QUE e POR QUE
- Use imperativos: "adiciona" não "adicionou"

Rodapé (opcional):
- BREAKING CHANGE: descrição da mudança incompatível
- Closes #123
- Refs #456
```

#### Tipos Válidos
- `feat`: nova funcionalidade
- `fix`: correção de bug
- `docs`: alterações na documentação
- `style`: formatação (sem mudança de código)
- `refactor`: refatoração de código
- `test`: adição/modificação de testes
- `chore`: tarefas de build, configurações
- `ci`: alterações em CI/CD
- `perf`: melhorias de performance
- `revert`: reverte commit anterior

#### Escopos Sugeridos para AutomatizaSE
- `subscription`: planos e assinaturas
- `stripe`: integração com Stripe
- `i18n`: tradução e internacionalização
- `auth`: autenticação e autorização
- `ui`: interface do usuário
- `api`: API e endpoints
- `database`: migrações e modelos
- `config`: configurações
- `test`: testes

### 3. Pre-commit Hooks

O projeto utiliza **Husky** e **lint-staged** para qualidade de código:

#### Verificações Automáticas
- **ESLint**: Linting de arquivos JavaScript/Vue
- **RuboCop**: Linting de arquivos Ruby
- **Prettier**: Formatação automática
- **SCSS-Lint**: Verificação de arquivos SCSS

#### Comandos Manuais
```bash
# Lint JavaScript/Vue
npm run eslint:fix

# Lint Ruby
bundle exec rubocop -a

# Executar todos os testes
npm test
bundle exec rspec
```

## Configuração do Ambiente

### Requisitos
- Node.js 23.x (conforme .nvmrc)
- Ruby 3.3.3 (conforme .ruby-version)
- PNPM 10.x
- PostgreSQL 16+
- Redis

### Setup Inicial
```bash
# Instalar Node.js correto
nvm install 23.7.0
nvm use 23.7.0

# Instalar dependências
pnpm install
bundle install

# Configurar template de commit
git config commit.template .gitmessage

# Configurar hooks (já feito automaticamente pelo husky)
pnpm run prepare
```

## Integração com AutomatizaSE

### Variáveis de Ambiente
- Copie `.env.example` para `.env` e configure:
  - `STRIPE_*`: Credenciais do Stripe para mercado brasileiro
  - `DEFAULT_LOCALE=pt-BR`: Idioma padrão
  - `MAILER_SENDER_EMAIL`: Email do AutomatizaSE

### Configurações Específicas
- **Idioma**: Português Brasileiro (pt-BR) como padrão
- **Moeda**: Real Brasileiro (BRL) no Stripe
- **Templates**: Mensagens e emails em português
- **Planos**: Hacker (Gratuito), Startups, Business, Enterprise

## Merge e Deploy

### Pull Requests
1. Criar PR da feature branch para `develop`
2. Aguardar revisão de código
3. Verificar que todos os checks passam
4. Merge após aprovação

### Deploy
- **Staging**: Deploy automático da branch `develop`
- **Production**: Deploy da branch `main` após merge de `develop`

## Troubleshooting

### Problemas Comuns

#### Pre-commit hook falha
```bash
# Verificar e corrigir linting
npm run eslint:fix
bundle exec rubocop -a

# Refazer commit
git add .
git commit
```

#### Conflitos de merge
```bash
# Resolver conflitos manualmente
# Então finalizar merge
git add .
git commit
```

#### Problemas com Husky
```bash
# Reinstalar hooks
pnpm run prepare
chmod +x .husky/pre-commit
```

## Comandos Úteis

```bash
# Ver status com branches
git status -b

# Ver log formatado
git log --oneline --graph -10

# Limpar branches locais órfãs
git branch -d $(git branch --merged | grep -v main | grep -v develop)

# Atualizar develop
git checkout develop && git pull origin develop

# Verificar lint antes de commit
npm run eslint && bundle exec rubocop
```

---

**Última atualização**: 28/05/2025
**Responsável**: Equipe AutomatizaSE 