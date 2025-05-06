#!/usr/bin/env ruby

# Script para habilitar recursos enterprise no Chatwoot
# Modo de uso: execute no console do Rails com:
# load 'enable_enterprise_features.rb'

# 1. Configurar a instalação para o plano enterprise
enterprise_plan = InstallationConfig.find_by(name: 'INSTALLATION_PRICING_PLAN')
enterprise_plan.value = 'enterprise' if enterprise_plan
enterprise_plan.save! if enterprise_plan

# 2. Forçar a atualização do ChatwootHub
# Este módulo é usado para determinar qual plano está ativo
def reload_chatwoot_hub
  Object.send(:remove_const, :ChatwootHub) if Object.const_defined?(:ChatwootHub)
  load Rails.root.join('lib/chatwoot_hub.rb')
  puts "ChatwootHub recarregado. Plano atual: #{ChatwootHub.pricing_plan}"
end

reload_chatwoot_hub

# 3. Desativar o serviço de reconciliação para o plano comunidade
# Este serviço normalmente desativa recursos premium em planos community
class Internal::ReconcilePlanConfigService
  alias_method :original_perform, :perform
  
  def perform
    remove_premium_config_reset_warning
    # Não fazemos a reconciliação para não desativar os recursos
    # return if ChatwootHub.pricing_plan != 'community'
    # 
    # create_premium_config_reset_warning if premium_config_reset_required?
    # 
    # reconcile_premium_config
    # reconcile_premium_features
  end
end

puts "Serviço de reconciliação modificado para preservar recursos premium"

# 4. Habilitar recursos premium para todas as contas
Account.find_each do |account|
  # Obter recursos do arquivo premium_features.yml
  config_path = Rails.root.join('enterprise/config')
  premium_features = YAML.safe_load(File.read("#{config_path}/premium_features.yml")).freeze
  
  # Habilitar recursos premium
  account.enable_features(*premium_features)
  account.save!
  
  puts "Habilitados recursos premium para conta: #{account.name}"
end

# 5. Verificar e atualizar a interface
begin
  if Rails.env.development?
    puts "Executando em modo desenvolvimento - reinicie o servidor para aplicar as alterações"
  else
    puts "Execute 'sudo systemctl restart chatwoot.target' para reiniciar o Chatwoot e aplicar as alterações"
  end
rescue => e
  puts "Erro ao reiniciar o Chatwoot: #{e.message}"
end

puts "Recursos enterprise habilitados com sucesso!" 