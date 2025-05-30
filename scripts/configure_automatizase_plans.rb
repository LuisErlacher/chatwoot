#!/usr/bin/env ruby

# Script para configurar os planos AutomatizaSe no Chatwoot
# Baseado nos arquivos planos_automatizase_comercial.md e planos_automatizase_en_features.md

# Configuração dos planos AutomatizaSe para o mercado brasileiro
automatizase_plans = [
  {
    'name' => 'Hacker',
    'product_id' => ['prod_automatizase_hacker'],
    'price_ids' => ['price_automatizase_hacker_monthly'],
    'price_brl' => 0,
    'currency' => 'brl',
    'interval' => 'month',
    'description' => 'Plano gratuito com funcionalidades básicas',
    'max_agents' => 2,
    'max_conversations_per_month' => 500,
    'max_inboxes' => 1,
    'inbox_types_allowed' => ['Channel::Api'], # Apenas API Evolution por enquanto
    'features' => []
  },
  {
    'name' => 'Startups',
    'product_id' => ['prod_automatizase_startups'],
    'price_ids' => ['price_automatizase_startups_monthly'],
    'price_brl' => 9500, # R$ 95,00 em centavos
    'currency' => 'brl',
    'interval' => 'month',
    'description' => 'Plano para startups com recursos essenciais',
    'max_agents' => 999,
    'max_conversations_per_month' => 999999,
    'max_inboxes' => 999,
    'inbox_types_allowed' => ['Channel::Api', 'Channel::Email', 'Channel::FacebookPage', 'Channel::Instagram', 'Channel::Sms', 'Channel::Telegram', 'Channel::Line'],
    'features' => [
      'inbound_emails',
      'help_center', 
      'channel_email',
      'channel_facebook',
      'channel_instagram',
      'channel_sms',
      'channel_telegram',
      'channel_line',
      'custom_views',
      'custom_filters',
      'business_hours',
      'auto_responder',
      'contact_segments',
      'contact_notes',
      'conversation_reports',
      'agent_reports',
      'inbox_reports',
      'label_reports',
      'team_reports'
    ]
  },
  {
    'name' => 'Business',
    'product_id' => ['prod_automatizase_business'],
    'price_ids' => ['price_automatizase_business_monthly'],
    'price_brl' => 19500, # R$ 195,00 em centavos
    'currency' => 'brl',
    'interval' => 'month',
    'description' => 'Plano para empresas com recursos avançados',
    'max_agents' => 999,
    'max_conversations_per_month' => 999999,
    'max_inboxes' => 999,
    'inbox_types_allowed' => ['Channel::Api', 'Channel::Email', 'Channel::FacebookPage', 'Channel::Instagram', 'Channel::Sms', 'Channel::Telegram', 'Channel::Line'],
    'features' => [
      'inbound_emails',
      'help_center',
      'channel_email',
      'channel_facebook', 
      'channel_instagram',
      'channel_sms',
      'channel_telegram',
      'channel_line',
      'custom_views',
      'custom_filters',
      'business_hours',
      'auto_responder',
      'contact_segments',
      'contact_notes',
      'conversation_reports',
      'agent_reports',
      'inbox_reports',
      'label_reports',
      'team_reports',
      'teams',
      'automation',
      'agent_capacity',
      'campaigns',
      'csat_reports',
      'sla',
      'downloadable_reports',
      'crm_integrations',
      'captain_integration'
    ]
  },
  {
    'name' => 'Enterprise',
    'product_id' => ['prod_automatizase_enterprise'],
    'price_ids' => ['price_automatizase_enterprise_monthly'],
    'price_brl' => 49500, # R$ 495,00 em centavos
    'currency' => 'brl',
    'interval' => 'month',
    'description' => 'Plano corporativo com recursos completos e personalizações',
    'max_agents' => 999,
    'max_conversations_per_month' => 999999,
    'max_inboxes' => 999,
    'inbox_types_allowed' => ['Channel::Api', 'Channel::Email', 'Channel::FacebookPage', 'Channel::Instagram', 'Channel::Sms', 'Channel::Telegram', 'Channel::Line'],
    'features' => [
      'inbound_emails',
      'help_center',
      'channel_email',
      'channel_facebook',
      'channel_instagram', 
      'channel_sms',
      'channel_telegram',
      'channel_line',
      'custom_views',
      'custom_filters',
      'business_hours',
      'auto_responder',
      'contact_segments',
      'contact_notes',
      'conversation_reports',
      'agent_reports',
      'inbox_reports',
      'label_reports',
      'team_reports',
      'teams',
      'automation',
      'agent_capacity',
      'campaigns',
      'csat_reports',
      'sla',
      'downloadable_reports',
      'crm_integrations',
      'captain_integration',
      'custom_ai_agents',
      'external_integrations',
      'google_calendar_integration',
      'payment_gateway_integration',
      'erp_crm_integration',
      'audit_logs',
      'disable_branding',
      'dedicated_support'
    ]
  }
]

puts "Configuração dos planos AutomatizaSe criada!"
puts "Para aplicar no banco de dados, execute:"
puts "InstallationConfig.find_or_create_by(name: 'CHATWOOT_CLOUD_PLANS') do |config|"
puts "  config.value = #{automatizase_plans.inspect}"
puts "  config.display_title = 'Planos AutomatizaSe'"
puts "  config.description = 'Configuração dos planos comerciais AutomatizaSe para o mercado brasileiro'"
puts "end" 