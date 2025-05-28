# AutomatizaSE - Variáveis de Ambiente

Este documento descreve todas as variáveis de ambiente necessárias para configurar e executar o AutomatizaSE corretamente.

## Variáveis Obrigatórias

### Configuração Básica

```bash
# Habilita as funcionalidades específicas do AutomatizaSE
AUTOMATIZASE_ENABLED=true

# Endpoint da API do AutomatizaSE para integrações
AUTOMATIZASE_API_ENDPOINT=https://api.automatizase.com

# Token de autenticação para os serviços do AutomatizaSE
AUTOMATIZASE_AUTH_TOKEN=your_auth_token_here
```

### Configuração do Stripe

```bash
# Chave pública do Stripe (visível no frontend)
STRIPE_PUBLISHABLE_KEY=pk_test_your_publishable_key_here

# Chave secreta do Stripe (apenas backend)
STRIPE_SECRET_KEY=sk_test_your_secret_key_here

# Segredo do webhook do Stripe para validação de requests
STRIPE_WEBHOOK_SECRET=whsec_your_webhook_secret_here
```

### Configuração da Evolution API (WhatsApp)

```bash
# Habilita integração WhatsApp via Evolution API
EVOLUTION_API_ENABLED=true

# URL base da sua instância Evolution API
EVOLUTION_API_BASE_URL=https://your-evolution-api-domain.com

# Chave da API para autenticação com Evolution API
EVOLUTION_API_KEY=your_evolution_api_key_here

# Chave global da API (se usando autenticação global)
EVOLUTION_API_GLOBAL_KEY=your_global_api_key_here

# URL do webhook que a Evolution API usará para enviar mensagens
EVOLUTION_WEBHOOK_URL=https://your-chatwoot-domain.com/webhooks/whatsapp/evolution

# Token secreto para validação de webhooks da Evolution API
EVOLUTION_WEBHOOK_SECRET=your_webhook_secret_here
```

## Variáveis Opcionais

### Funcionalidades Premium

```bash
# Habilita funcionalidades avançadas (requer plano premium)
AUTOMATIZASE_PREMIUM_FEATURES=false
```

### Configuração de Webhooks

```bash
# Habilita integração via webhooks para workflows de automação
AUTOMATIZASE_WEBHOOK_ENABLED=true

# Chave secreta para validar requests de webhook do AutomatizaSE
AUTOMATIZASE_WEBHOOK_SECRET=your_webhook_secret_here
```

### Configurações de Limite e Analytics

```bash
# Número máximo de regras de automação por conta
AUTOMATIZASE_MAX_AUTOMATION_RULES=50

# Habilita integração de analytics e relatórios
AUTOMATIZASE_ANALYTICS_ENABLED=true
```

## Configuração para Diferentes Ambientes

### Desenvolvimento

```bash
AUTOMATIZASE_ENABLED=true
AUTOMATIZASE_API_ENDPOINT=https://api-dev.automatizase.com
AUTOMATIZASE_PREMIUM_FEATURES=true
STRIPE_PUBLISHABLE_KEY=pk_test_...
STRIPE_SECRET_KEY=sk_test_...
```

### Produção

```bash
AUTOMATIZASE_ENABLED=true
AUTOMATIZASE_API_ENDPOINT=https://api.automatizase.com
AUTOMATIZASE_PREMIUM_FEATURES=false
STRIPE_PUBLISHABLE_KEY=pk_live_...
STRIPE_SECRET_KEY=sk_live_...
```

## Como Configurar

### 1. Arquivo .env Local

Crie um arquivo `.env` na raiz do projeto com as variáveis necessárias:

```bash
cp env.example .env
```

Edite o arquivo `.env` e adicione os valores das variáveis específicas do AutomatizaSE.

### 2. Rails Credentials (Produção)

Para ambientes de produção, use Rails credentials para armazenar secrets sensíveis:

```bash
rails credentials:edit
```

Adicione a estrutura:

```yaml
automatizase:
  auth_token: your_auth_token
  webhook_secret: your_webhook_secret
stripe:
  publishable_key: pk_live_...
  secret_key: sk_live_...
  webhook_secret: whsec_...
```

### 3. Docker Compose

Para executar com Docker, adicione as variáveis no arquivo `docker-compose.yml`:

```yaml
services:
  app:
    environment:
      - AUTOMATIZASE_ENABLED=true
      - AUTOMATIZASE_API_ENDPOINT=https://api.automatizase.com
      - STRIPE_PUBLISHABLE_KEY=${STRIPE_PUBLISHABLE_KEY}
      - STRIPE_SECRET_KEY=${STRIPE_SECRET_KEY}
```

## Verificação da Configuração

Para verificar se as variáveis estão configuradas corretamente, execute:

```bash
rails console
```

E teste:

```ruby
# Verificar configurações do AutomatizaSE
Rails.application.config.automatizase_enabled
ENV['STRIPE_PUBLISHABLE_KEY']
GlobalConfig.get('AUTOMATIZASE_ENABLED')['value']
```

## Notas Importantes

1. **Nunca commite** chaves secretas no controle de versão
2. Use **chaves de teste** do Stripe em desenvolvimento
3. Configure **webhooks** do Stripe apontando para o endpoint correto
4. As configurações em `installation_config.yml` sobrescrevem variáveis de ambiente
5. Reinicie o servidor após mudanças nas variáveis de ambiente

## Suporte

Para mais informações sobre configuração específica, consulte:
- [Documentação do Stripe](https://stripe.com/docs)
- [Rails Credentials Guide](https://guides.rubyonrails.org/security.html#custom-credentials)
- [AutomatizaSE API Documentation](https://docs.automatizase.com) 