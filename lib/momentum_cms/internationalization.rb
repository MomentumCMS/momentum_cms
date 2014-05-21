module MomentumCms
  class Internationalization
    @lookup = {
      'en' => ['English', 'English'],
      'af' => ['Afrikaans', 'Afrikaans'],
      'ar' => ['Arabic', 'العربية'],
      'az' => ['Azerbaijani', 'azərbaycan dili'],
      'bg' => ['Bulgarian', 'български език'],
      'bn' => ['Bengali, Bangla', 'বাংলা'],
      'bs' => ['Bosnian', 'bosanski jezik'],
      'ca' => ['Catalan, Valencian', 'català, valencià'],
      'cs' => ['Czech', 'čeština, český jazyk'],
      'cy' => ['Welsh', 'Cymraeg'],
      'da' => ['Danish', 'dansk'],
      'de-AT' => ['', ''],
      'de-CH' => ['', ''],
      'de' => ['German', 'Deutsch'],
      'el' => ['Greek', 'ελληνικά'],
      'en-AU' => ['', ''],
      'en-CA' => ['', ''],
      'en-GB' => ['', ''],
      'en-IE' => ['', ''],
      'en-IN' => ['', ''],
      'en-NZ' => ['', ''],
      'en-US' => ['', ''],
      'eo' => ['Esperanto', 'Esperanto'],
      'es-419' => ['', ''],
      'es-AR' => ['', ''],
      'es-CL' => ['', ''],
      'es-CO' => ['', ''],
      'es-CR' => ['', ''],
      'es-MX' => ['', ''],
      'es-PA' => ['', ''],
      'es-PE' => ['', ''],
      'es-VE' => ['', ''],
      'es' => ['Spanish, Castilian', 'español, castellano'],
      'et' => ['Estonian', 'eesti, eesti keel'],
      'eu' => ['Basque', 'euskara, euskera'],
      'fa' => ['Persian (Farsi)', 'فارسی'],
      'fi' => ['Finnish', 'suomi, suomen kieli'],
      'fr-CA' => ['', ''],
      'fr-CH' => ['', ''],
      'fr' => ['', ''],
      'gl' => ['', ''],
      'he' => ['', ''],
      'hi-IN' => ['', ''],
      'hi' => ['', ''],
      'hr' => ['', ''],
      'hu' => ['', ''],
      'id' => ['', ''],
      'is' => ['', ''],
      'it-CH' => ['', ''],
      'it' => ['', ''],
      'ja' => ['', ''],
      'kn' => ['', ''],
      'ko' => ['', ''],
      'lo' => ['', ''],
      'lt' => ['', ''],
      'lv' => ['', ''],
      'mk' => ['', ''],
      'mn' => ['', ''],
      'ms' => ['', ''],
      'nb' => ['', ''],
      'ne' => ['', ''],
      'nl' => ['', ''],
      'nn' => ['', ''],
      'or' => ['', ''],
      'pl' => ['', ''],
      'pt-BR' => ['', ''],
      'pt' => ['', ''],
      'rm' => ['', ''],
      'ro' => ['', ''],
      'ru' => ['', ''],
      'sk' => ['', ''],
      'sl' => ['', ''],
      'sr' => ['', ''],
      'sv' => ['', ''],
      'sw' => ['', ''],
      'th' => ['', ''],
      'tl' => ['', ''],
      'tr' => ['', ''],
      'uk' => ['', ''],
      'ur' => ['', ''],
      'uz' => ['', ''],
      'vi' => ['', ''],
      'wo' => ['', ''],
      'zh-CN' => ['', ''],
      'zh-HK' => ['', ''],
      'zh-TW' => ['', '']
    }

    def self.lookup(locale)
      locale = locale.to_s
      if @lookup.has_key?(locale)
        @lookup[locale].join(' ')
      else
        locale
      end
    end

    def self.register(locale, label)
      locale = locale.to_s
      if lookup(locale) == locale
        @lookup[locale] = label
      end
    end

  end
end
