# frozen_string_literal: true

# Configuração de formatos de data/hora para português brasileiro
# Baseado nos padrões brasileiros (DD/MM/YYYY)

# Configurar formatos de data
Date::DATE_FORMATS[:default] = '%d/%m/%Y'
Date::DATE_FORMATS[:short] = '%d/%m'
Date::DATE_FORMATS[:long] = '%d de %B de %Y'
Date::DATE_FORMATS[:db] = '%Y-%m-%d'

# Configurar formatos de hora
Time::DATE_FORMATS[:default] = '%d/%m/%Y %H:%M'
Time::DATE_FORMATS[:short] = '%d/%m %H:%M'
Time::DATE_FORMATS[:long] = '%d de %B de %Y às %H:%M'
Time::DATE_FORMATS[:time] = '%H:%M'
Time::DATE_FORMATS[:db] = '%Y-%m-%d %H:%M:%S'

# Configurar formatos para DateTime
DateTime::DATE_FORMATS = Time::DATE_FORMATS 