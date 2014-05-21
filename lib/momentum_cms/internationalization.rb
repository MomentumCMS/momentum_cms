#encoding: utf-8
module MomentumCms
  class Internationalization
    @lookup = {
      'en' => ['English', ''],
      'af' => ['Afrikaans', ''],
      'ar' => ['Arabic', ''],
      'az' => ['Azerbaijani', ''],
      'bg' => ['Bulgarian', ''],
      'bn' => ['Bengali, Bangla', ''],
      'bs' => ['Bosnian', ''],
      'ca' => ['Catalan, Valencian', ''],
      'cs' => ['Czech', ''],
      'cy' => ['Welsh', ''],
      'da' => ['Danish', ''],
      'de-AT' => ['', ''],
      'de-CH' => ['', ''],
      'de' => ['German', ''],
      'el' => ['Greek', ''],
      'en-AU' => ['', ''],
      'en-CA' => ['', ''],
      'en-GB' => ['', ''],
      'en-IE' => ['', ''],
      'en-IN' => ['', ''],
      'en-NZ' => ['', ''],
      'en-US' => ['', ''],
      'eo' => ['Esperanto', ''],
      'es-419' => ['', ''],
      'es-AR' => ['', ''],
      'es-CL' => ['', ''],
      'es-CO' => ['', ''],
      'es-CR' => ['', ''],
      'es-MX' => ['', ''],
      'es-PA' => ['', ''],
      'es-PE' => ['', ''],
      'es-VE' => ['', ''],
      'es' => ['Spanish, Castilian', ''],
      'et' => ['Estonian', ''],
      'eu' => ['Basque', ''],
      'fa' => ['Persian (Farsi)', ''],
      'fi' => ['Finnish', ''],
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
        @lookup[locale].compact.join(' ')
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
