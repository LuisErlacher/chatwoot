# Este inicializador garante que os recursos enterprise estejam sempre disponíveis
# Ele modifica os serviços de reconciliação e ativa os recursos premium para novas contas

Rails.application.config.to_prepare do
  # 1. Sobreescrever o serviço de reconciliação para evitar desativação de recursos premium
  Internal::ReconcilePlanConfigService.class_eval do
    def perform
      # Apenas remover avisos, mas não reconciliar configurações premium
      remove_premium_config_reset_warning
    end
  end

  # 2. Habilitar recursos premium para novas contas
  Account.class_eval do
    after_create :enable_premium_features
    
    def enable_premium_features
      begin
        config_path = Rails.root.join('enterprise/config')
        premium_features = YAML.safe_load(File.read("#{config_path}/premium_features.yml")).freeze
        enable_features(*premium_features)
        save!
      rescue => e
        Rails.logger.error "Erro ao habilitar recursos premium: #{e.message}"
      end
    end
  end
end 