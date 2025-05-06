# Ativação dos Recursos Enterprise do Chatwoot

Este documento descreve como ativar os recursos premium/enterprise do Chatwoot em uma instalação self-hosted.

## Pré-requisitos

- Você precisa ter acesso ao console do Rails e aos arquivos do Chatwoot
- Seu Chatwoot deve ser da versão enterprise (com os arquivos na pasta /enterprise)

## Instruções passo a passo

1. **Descomente os recursos premium no arquivo de configuração**

   Edite o arquivo `enterprise/config/premium_features.yml` e remova os comentários (`#`) de todos os recursos:

   ```yaml
   # List of the premium features in EE edition
   - disable_branding
   - audit_logs
   - response_bot
   - sla
   - captain_integration
   - custom_roles
   ```

2. **Configure o plano como enterprise**

   Verifique se o arquivo `config/installation_config.yml` tem a configuração correta:

   ```yaml
   - name: INSTALLATION_PRICING_PLAN
     value: 'enterprise'
     description: 'The pricing plan for the installation, retrieved from the billing API'
   ```

3. **Execute o script para ativar os recursos**

   Execute o seguinte comando no console do Rails:

   ```bash
   # Acesse o console do Rails
   cd /caminho/para/chatwoot
   rails console

   # No console do Rails, carregue o script
   load 'enable_enterprise_features.rb'
   ```

4. **Reinicie o servidor Chatwoot**

   ```bash
   # Para sistemas que usam systemd
   sudo systemctl restart chatwoot.target

   # Para desenvolvimento
   # Reinicie o servidor Rails manualmente
   ```

## Como funciona

O script faz as seguintes alterações:

1. Define o plano da instalação como "enterprise"
2. Recarrega o módulo ChatwootHub para reconhecer a alteração
3. Modifica o serviço de reconciliação para não desativar recursos premium
4. Habilita os recursos premium para todas as contas existentes

## Solução de problemas

Se os recursos não aparecerem após reiniciar:

1. Verifique se os arquivos foram modificados corretamente
2. Verifique se o plano está definido como 'enterprise' no console:
   ```ruby
   ChatwootHub.pricing_plan
   # Deve retornar "enterprise"
   ```
3. Verifique se os recursos estão habilitados para a conta:
   ```ruby
   Account.first.enabled_features
   # Deve incluir os recursos premium como "disable_branding", etc.
   ```

## Observações

Esta modificação é não-oficial e pode ser afetada por atualizações futuras do Chatwoot. Após atualizar, talvez seja necessário aplicar as alterações novamente.

## Ativação Permanente (Modo Definitivo)

Para evitar a necessidade de executar o script após cada atualização, você pode fazer modificações permanentes no código fonte. Estas alterações garantem que o Chatwoot sempre opere no modo enterprise, independentemente das configurações.

### Alterações implementadas

1. **Modificação do ChatwootHub (lib/chatwoot_hub.rb)**
   - O método `pricing_plan` foi alterado para sempre retornar 'enterprise'
   - O método `pricing_plan_quantity` foi modificado para retornar 999 por padrão, evitando limitações

   ```ruby
   def self.pricing_plan
     # Modificado para sempre retornar 'enterprise' independente da configuração
     'enterprise'
   end

   def self.pricing_plan_quantity
     # Modificado para retornar um valor maior por padrão para evitar limitações
     InstallationConfig.find_by(name: 'INSTALLATION_PRICING_PLAN_QUANTITY')&.value || 999
   end
   ```

2. **Criação de um inicializador (config/initializers/enterprise_override.rb)**
   - Sobrescreve o serviço de reconciliação para não desativar recursos premium
   - Adiciona um callback nas contas para habilitar automaticamente recursos premium em novas contas

   ```ruby
   Rails.application.config.to_prepare do
     # Sobreescrever o serviço de reconciliação
     Internal::ReconcilePlanConfigService.class_eval do
       def perform
         # Apenas remover avisos, mas não reconciliar configurações premium
         remove_premium_config_reset_warning
       end
     end

     # Habilitar recursos premium para novas contas
     Account.class_eval do
       after_create :enable_premium_features
       
       def enable_premium_features
         config_path = Rails.root.join('enterprise/config')
         premium_features = YAML.safe_load(File.read("#{config_path}/premium_features.yml")).freeze
         enable_features(*premium_features)
         save!
       end
     end
   end
   ```

### Vantagens do modo definitivo

- Não é necessário executar o script após cada atualização
- Os recursos premium estarão sempre disponíveis automaticamente
- Novas contas criadas já terão os recursos premium habilitados
- O sistema não tentará desabilitar recursos mesmo após atualizações

### Notas importantes sobre o modo definitivo

- Após uma atualização, verifique se os arquivos modificados não foram sobrescritos
- Se necessário, reaplique as modificações em `lib/chatwoot_hub.rb` e `config/initializers/enterprise_override.rb`
- Certifique-se que o arquivo `enterprise/config/premium_features.yml` continua com os recursos descomentados 