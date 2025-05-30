# frozen_string_literal: true

# BrandHelper - Helper para views que facilita o uso das configurações de marca
module BrandHelper
  # Métodos de acesso rápido para informações da marca
  def brand_name
    BrandConfig.name
  end

  def brand_display_name
    BrandConfig.display_name
  end

  def brand_tagline
    BrandConfig.tagline
  end

  def brand_description
    BrandConfig.description
  end

  # URLs da marca
  def brand_website
    BrandConfig.website
  end

  def brand_support_email
    BrandConfig.support_email
  end

  def brand_terms_url
    BrandConfig.terms_url
  end

  def brand_privacy_url
    BrandConfig.privacy_url
  end

  # Assets da marca
  def brand_logo(options = {})
    logo_path = BrandConfig.logo
    alt_text = options[:alt] || brand_display_name
    css_class = options[:class] || 'brand-logo'
    
    image_tag(logo_path, alt: alt_text, class: css_class)
  end

  def brand_logo_dark(options = {})
    logo_path = BrandConfig.logo_dark
    alt_text = options[:alt] || "#{brand_display_name} (modo escuro)"
    css_class = options[:class] || 'brand-logo-dark'
    
    image_tag(logo_path, alt: alt_text, class: css_class)
  end

  def brand_logo_thumbnail(options = {})
    logo_path = BrandConfig.logo_thumbnail
    alt_text = options[:alt] || brand_display_name
    css_class = options[:class] || 'brand-logo-thumbnail'
    
    image_tag(logo_path, alt: alt_text, class: css_class)
  end

  def brand_favicon_link_tag
    tag.link(rel: 'icon', type: 'image/x-icon', href: BrandConfig.favicon)
  end

  # Cores da marca
  def brand_primary_color
    BrandConfig.primary_color
  end

  def brand_secondary_color
    BrandConfig.secondary_color
  end

  def brand_accent_color
    BrandConfig.accent_color
  end

  def brand_color(name)
    BrandConfig.color(name)
  end

  # CSS custom properties para cores
  def brand_css_variables
    BrandConfig.css_variables.html_safe
  end

  # Fontes da marca
  def brand_primary_font
    BrandConfig.primary_font
  end

  def brand_secondary_font
    BrandConfig.secondary_font
  end

  # Meta tags para SEO e Open Graph
  def brand_meta_tags
    tags = []
    
    # Meta tags básicas
    tags << tag.meta(name: 'description', content: brand_description)
    tags << tag.meta(name: 'author', content: brand_display_name)
    
    # Open Graph
    tags << tag.meta(property: 'og:site_name', content: brand_display_name)
    tags << tag.meta(property: 'og:type', content: 'website')
    tags << tag.meta(property: 'og:url', content: brand_website)
    tags << tag.meta(property: 'og:title', content: brand_display_name)
    tags << tag.meta(property: 'og:description', content: brand_description)
    tags << tag.meta(property: 'og:image', content: asset_url(BrandConfig.logo_thumbnail))
    
    # Twitter Card
    tags << tag.meta(name: 'twitter:card', content: 'summary')
    tags << tag.meta(name: 'twitter:site', content: BrandConfig.social_media('twitter'))
    tags << tag.meta(name: 'twitter:title', content: brand_display_name)
    tags << tag.meta(name: 'twitter:description', content: brand_description)
    tags << tag.meta(name: 'twitter:image', content: asset_url(BrandConfig.logo_thumbnail))
    
    # Theme color para mobile
    tags << tag.meta(name: 'theme-color', content: brand_primary_color)
    tags << tag.meta(name: 'msapplication-TileColor', content: brand_primary_color)
    
    safe_join(tags, "\n")
  end

  # Links para redes sociais
  def brand_social_link(platform, options = {})
    social_handle = BrandConfig.social_media(platform)
    return '' unless social_handle.present?

    url = case platform.to_s
          when 'twitter'
            "https://twitter.com/#{social_handle.gsub('@', '')}"
          when 'linkedin'
            "https://linkedin.com/#{social_handle}"
          when 'facebook'
            "https://facebook.com/#{social_handle}"
          when 'instagram'
            "https://instagram.com/#{social_handle.gsub('@', '')}"
          else
            social_handle
          end

    link_text = options[:text] || social_handle
    css_class = options[:class] || "brand-social-#{platform}"
    target = options[:target] || '_blank'
    
    link_to(link_text, url, class: css_class, target: target, rel: 'noopener')
  end

  # Verificar se features brasileiras estão habilitadas
  def brazilian_features_enabled?
    BrandConfig.brazilian_features_enabled?
  end

  def brand_feature_enabled?(feature_name)
    BrandConfig.feature_enabled?(feature_name)
  end

  # Localização
  def brand_locale
    BrandConfig.locale
  end

  def brand_timezone
    BrandConfig.timezone
  end

  def brand_currency
    BrandConfig.currency
  end

  # Método para gerar título da página com marca
  def brand_page_title(page_title = nil)
    if page_title.present?
      "#{page_title} | #{brand_display_name}"
    else
      "#{brand_display_name} - #{brand_tagline}"
    end
  end

  # Método para gerar link "Powered by"
  def brand_powered_by_link(options = {})
    link_text = options[:text] || "Powered by #{brand_display_name}"
    css_class = options[:class] || 'brand-powered-by'
    
    link_to(link_text, brand_website, class: css_class, target: '_blank', rel: 'noopener')
  end

  # Método para verificar se o sistema de marca está carregado
  def brand_config_loaded?
    BrandConfig.loaded?
  end

  # Métodos adicionais para compatibilidade com configurações globais existentes
  
  # Nome da instalação (equivalente a INSTALLATION_NAME)
  def installation_name
    brand_display_name
  end

  # Método para substituir o uso de @global_config['INSTALLATION_NAME']
  def page_title_with_brand(page_title = nil)
    brand_page_title(page_title)
  end

  # Email de suporte formatado
  def support_email_link(options = {})
    email = brand_support_email
    return '' unless email.present?

    link_text = options[:text] || email
    subject = options[:subject] || "Suporte #{brand_display_name}"
    css_class = options[:class] || 'support-email-link'
    
    mail_to(email, link_text, subject: subject, class: css_class)
  end

  # Verificação se features estão habilitadas (para compatibilidade)
  def brand_signup_enabled?
    # Esta seria uma configuração que poderia ser movida para o brand config
    global_config('ENABLE_ACCOUNT_SIGNUP') == 'true'
  end

  # Helper para acessar configurações globais quando necessário
  def global_config(key)
    GlobalConfig.get(key)&.fetch('value', nil)
  end
end 