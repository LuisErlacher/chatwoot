# frozen_string_literal: true

# Inicializador do sistema de configuração de marca AutomatizaSE
# Carrega as configurações e atualiza o GlobalConfig se necessário

Rails.application.configure do
  # Carregar configurações de marca na inicialização
  config.after_initialize do
    begin
      # Verificar se o arquivo de configuração existe
      brand_config_path = Rails.root.join('config', 'brand.yml')
      
      if File.exist?(brand_config_path)
        # Carregar configurações de marca
        brand_config = BrandConfig.instance
        
        if brand_config.loaded?
          Rails.logger.info "✅ Configurações de marca AutomatizaSE carregadas com sucesso"
          
          # Atualizar GlobalConfig apenas em produção ou quando explicitamente solicitado
          if Rails.env.production? || ENV['UPDATE_BRAND_CONFIG'] == 'true'
            brand_config.update_global_config!
            Rails.logger.info "✅ GlobalConfig atualizado com configurações AutomatizaSE"
          end
        else
          Rails.logger.warn "⚠️  Arquivo de configuração de marca encontrado mas não pôde ser carregado"
        end
      else
        Rails.logger.warn "⚠️  Arquivo config/brand.yml não encontrado - usando configurações padrão"
      end
      
    rescue StandardError => e
      Rails.logger.error "❌ Erro ao inicializar configurações de marca: #{e.message}"
      Rails.logger.error e.backtrace.join("\n") if Rails.env.development?
    end
  end
end

# Adicionar constantes para facilitar o acesso
BRAND_NAME = 'AutomatizaSE'.freeze
BRAND_LOCALE = 'pt-BR'.freeze
BRAND_TIMEZONE = 'America/Sao_Paulo'.freeze
BRAND_CURRENCY = 'BRL'.freeze

# Configurar timezone padrão se as features brasileiras estiverem habilitadas
if defined?(BrandConfig) && BrandConfig.brazilian_features_enabled?
  Time.zone = BRAND_TIMEZONE
end 