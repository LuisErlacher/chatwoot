# frozen_string_literal: true

# BrandConfig - Sistema de configuração de marca para AutomatizaSE
# Carrega configurações do arquivo config/brand.yml e fornece métodos de acesso
class BrandConfig
  include Singleton

  def initialize
    @config = load_brand_config
  end

  class << self
    delegate_missing_to :instance
  end

  # Métodos principais de acesso
  def name
    @config.dig('brand', 'name') || 'AutomatizaSE'
  end

  def display_name
    @config.dig('brand', 'display_name') || name
  end

  def tagline
    @config.dig('brand', 'tagline') || 'Automatize seu atendimento ao cliente'
  end

  def description
    @config.dig('brand', 'description') || 'Plataforma brasileira de atendimento ao cliente'
  end

  # URLs
  def website
    @config.dig('brand', 'website') || 'https://www.automatizase.com'
  end

  def support_email
    @config.dig('brand', 'support_email') || 'contato@automatizase.com'
  end

  def terms_url
    @config.dig('brand', 'terms_url') || 'https://www.automatizase.com/termos-de-servico'
  end

  def privacy_url
    @config.dig('brand', 'privacy_url') || 'https://www.automatizase.com/politica-de-privacidade'
  end

  # Assets
  def logo
    @config.dig('brand', 'logo') || '/brand-assets/automatizase-logo.svg'
  end

  def logo_dark
    @config.dig('brand', 'logo_dark') || '/brand-assets/automatizase-logo-dark.svg'
  end

  def logo_thumbnail
    @config.dig('brand', 'logo_thumbnail') || '/brand-assets/automatizase-logo-thumbnail.svg'
  end

  def favicon
    @config.dig('brand', 'favicon') || '/brand-assets/favicon.ico'
  end

  # Cores
  def primary_color
    @config.dig('brand', 'colors', 'primary') || '#1B5E20'
  end

  def secondary_color
    @config.dig('brand', 'colors', 'secondary') || '#4CAF50'
  end

  def accent_color
    @config.dig('brand', 'colors', 'accent') || '#FFD700'
  end

  def color(name)
    @config.dig('brand', 'colors', name.to_s)
  end

  def colors
    @config.dig('brand', 'colors') || {}
  end

  # Fontes
  def primary_font
    @config.dig('brand', 'fonts', 'primary') || 'Inter, sans-serif'
  end

  def secondary_font
    @config.dig('brand', 'fonts', 'secondary') || 'Roboto, sans-serif'
  end

  # Localização
  def locale
    @config.dig('brand', 'locale') || 'pt-BR'
  end

  def timezone
    @config.dig('brand', 'timezone') || 'America/Sao_Paulo'
  end

  def currency
    @config.dig('brand', 'currency') || 'BRL'
  end

  # Features
  def feature_enabled?(feature_name)
    @config.dig('brand', 'features', feature_name.to_s) == true
  end

  def brazilian_features_enabled?
    feature_enabled?('brazilian_date_format') &&
      feature_enabled?('brazilian_phone_format') &&
      feature_enabled?('brazilian_currency')
  end

  # Redes sociais
  def social_media(platform)
    @config.dig('brand', 'social', platform.to_s)
  end

  # Método para obter toda a configuração
  def all
    @config['brand'] || {}
  end

  # Método para recarregar configuração (útil em desenvolvimento)
  def reload!
    @config = load_brand_config
  end

  # Método para verificar se a configuração foi carregada
  def loaded?
    @config.present? && @config['brand'].present?
  end

  # Método para gerar CSS custom properties
  def css_variables
    return '' unless colors.present?

    css_vars = colors.map do |name, value|
      "--brand-#{name.tr('_', '-')}: #{value};"
    end

    ":root {\n  #{css_vars.join("\n  ")}\n}"
  end

  # Método para integração com GlobalConfig
  def update_global_config!
    return unless loaded?

    configs_to_update = {
      'INSTALLATION_NAME' => name,
      'BRAND_NAME' => display_name,
      'BRAND_URL' => website,
      'WIDGET_BRAND_URL' => website,
      'TERMS_URL' => terms_url,
      'PRIVACY_URL' => privacy_url,
      'LOGO' => logo,
      'LOGO_DARK' => logo_dark,
      'LOGO_THUMBNAIL' => logo_thumbnail
    }

    configs_to_update.each do |config_name, config_value|
      installation_config = InstallationConfig.find_or_initialize_by(name: config_name)
      installation_config.value = config_value
      installation_config.save!
    end

    # Limpar cache do GlobalConfig
    GlobalConfig.clear_cache
  end

  private

  def load_brand_config
    config_path = Rails.root.join('config', 'brand.yml')
    return {} unless File.exist?(config_path)

    YAML.load_file(config_path) || {}
  rescue StandardError => e
    Rails.logger.error "Erro ao carregar configuração de marca: #{e.message}"
    {}
  end
end 