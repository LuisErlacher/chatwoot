# AutomatizaSE - Customização Chatwoot

Este é um fork customizado do Chatwoot para o projeto AutomatizaSE, com configurações específicas e melhorias personalizadas.

## 📁 Estrutura de Pastas Importantes

### `.cursor/`
Contém configurações do editor Cursor AI:
- `mcp.json.template`: Template para configuração do Model Context Protocol
- `rules/`: Regras específicas do projeto para o assistente de IA
- **IMPORTANTE:** O arquivo `mcp.json` com chaves reais é ignorado pelo Git

### `coverage/`
**O que é:** Relatórios de cobertura de testes gerados automaticamente
- `index.html`: Relatório visual da cobertura de testes
- `.resultset.json`: Dados detalhados da cobertura
- `assets/`: Recursos visuais do relatório

**Para que serve:** Monitora quais partes do código estão sendo testadas, ajudando a identificar áreas que precisam de mais testes.

### `tasks/`
Sistema de gerenciamento de tarefas do projeto:
- `tasks.json`: Lista principal de tarefas
- `task_*.txt`: Arquivos individuais de cada tarefa
- Usado para organizar e acompanhar o desenvolvimento

### `memory-bank/`
Sistema de memória do assistente de IA:
- Documentação contextual do projeto
- Padrões e decisões arquiteturais
- Estado atual do desenvolvimento

## 🔧 Configuração para Nova Máquina

### 1. Clone do Repositório
```bash
git clone [seu-repositorio-aqui]
cd chatwoot
```

### 2. Configuração do Ambiente
```bash
cp .env.example .env
# Edite o .env com suas configurações específicas
```

### 3. Configuração do Cursor AI
```bash
# Copie o template e configure suas chaves de API
cp .cursor/mcp.json.template .cursor/mcp.json
# Edite .cursor/mcp.json e substitua os placeholders pelas suas chaves reais:
# - ANTHROPIC_API_KEY_HERE -> sua chave do Anthropic
# - OPENAI_API_KEY_HERE -> sua chave do OpenAI
# - etc.
```

### 4. Configuração do Task Master
```bash
# O arquivo .taskmasterconfig será criado automaticamente
npm install -g task-master-ai
task-master models --setup
```

## 📊 Relatórios de Cobertura

Para visualizar a cobertura de testes:
```bash
# Executar testes e gerar relatório
bundle exec rspec
# Abrir relatório no navegador
open coverage/index.html
```

## 🚨 Importante - Configuração GitHub

**ATENÇÃO:** A pasta `.github/` contém workflows e configurações do Chatwoot original. 

### Problema Identificado:
- Os workflows apontam para repositórios do Chatwoot (`chatwoot/chatwoot`)
- Code owners apontam para `@sojan-official` (proprietário original)
- Actions podem tentar fazer deploy para infraestrutura do Chatwoot

### Recomendações:
1. **Remover ou modificar workflows** que não se aplicam ao seu projeto
2. **Atualizar CODEOWNERS** com seus próprios usuários
3. **Configurar secrets** específicos do seu projeto no GitHub

## 📝 Arquivos de Configuração Incluídos

- `.cursor/rules/`: Regras do Cursor AI ✅
- `.cursor/mcp.json.template`: Template de configuração ✅
- `coverage/`: Relatórios de cobertura de testes ✅
- `tasks/`: Sistema de gerenciamento de tarefas ✅
- `memory-bank/`: Contexto do assistente de IA ✅
- `.taskmasterconfig`: Configuração do Task Master ✅

## 🔐 Segurança

- Arquivo `.env` continua ignorado (contém dados sensíveis)
- Arquivo `.cursor/mcp.json` é ignorado (contém chaves de API)
- Chaves de API devem ser configuradas localmente
- **NUNCA** commitar credenciais ou tokens

## 🚀 Configuração Rápida (Script)

Execute após clonar o projeto:
```bash
# Limpar configurações do GitHub original
./scripts/cleanup_github_config.sh

# Configurar Cursor AI
cp .cursor/mcp.json.template .cursor/mcp.json
# Edite .cursor/mcp.json com suas chaves de API
```

## 📋 Próximos Passos

1. [ ] Revisar e limpar pasta `.github/`
2. [ ] Configurar CI/CD específico para AutomatizaSE
3. [ ] Atualizar documentação do projeto
4. [ ] Configurar ambiente de desenvolvimento
5. [ ] Configurar testes automatizados

---

**Nota:** Este é um projeto independente baseado no Chatwoot. As contribuições não são enviadas de volta para o projeto original. 