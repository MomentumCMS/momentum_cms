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
      'de-AT' => ['German (Austria)', ''],
      'de-CH' => ['German (Switzerland)', ''],
      'de' => ['German', ''],
      'el' => ['Greek', ''],
      'en-AU' => ['English (Australia)', ''],
      'en-CA' => ['English (Canada)', ''],
      'en-GB' => ['English (United Kingdom)', ''],
      'en-IE' => ['English (Ireland)', ''],
      'en-IN' => ['English (India)', ''],
      'en-NZ' => ['English (New Zealand)', ''],
      'en-US' => ['English (United States)', ''],
      'eo' => ['Esperanto', ''],
      'es-419' => ['Spanish as used in Latin America and the Caribbean', ''],
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
      'th' => ['Thai', ''],
      'tl' => ['', ''],
      'tr' => ['Turkish', ''],
      'uk' => ['Ukrainian', ''],
      'ur' => ['Urdu', ''],
      'uz' => ['', ''],
      'vi' => ['Vietnamese', ''],
      'wo' => ['', ''],
      'zh-CN' => ['Chinese (PRC)', ''],
      'zh-HK' => ['Chinese (Hong Kong SAR)', ''],
      'zh-TW' => ['Chinese (Taiwan)', '']
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
