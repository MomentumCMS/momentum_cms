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
      'ca' => ['Catalan', ''],
      'cs' => ['Czech', ''],
      'cy' => ['Welsh', ''],
      'da' => ['Danish', ''],
      'de' => ['German', ''],
      'el' => ['Greek', ''],
      'eo' => ['Esperanto', ''],
      'es' => ['Spanish', ''],
      'et' => ['Estonian', ''],
      'eu' => ['Basque', ''],
      'fa' => ['Persian', ''],
      'fi' => ['Finnish', ''],
      'fr' => ['French', ''],
      'gl' => ['Galician', ''],
      'he' => ['Hebrew', ''],
      'hi' => ['Hindi', ''],
      'hr' => ['Croatian', ''],
      'hu' => ['Hungarian', ''],
      'id' => ['Indonesian', ''],
      'is' => ['Icelandic', ''],
      'it' => ['Italian', ''],
      'ja' => ['Japanese', ''],
      'kn' => ['Kannada', ''],
      'ko' => ['Korean', ''],
      'lo' => ['Laothian', ''],
      'lt' => ['Lithuanian', ''],
      'lv' => ['Latvian', ''],
      'mk' => ['Macedonian', ''],
      'mn' => ['Mongolian', ''],
      'ms' => ['Malay', ''],
      'nb' => ['Norwegian Bokmal', ''],
      'ne' => ['Nepali', ''],
      'nl' => ['Dutch', ''],
      'nn' => ['Norwegian Nynorsk', ''],
      'or' => ['Oriya', ''],
      'pl' => ['Polish', ''],
      'pt' => ['Portuguese', ''],
      'ro' => ['Romanian', ''],
      'ru' => ['Russian', ''],
      'sk' => ['Slovak', ''],
      'sl' => ['Slovenian', ''],
      'sr' => ['Serbian', ''],
      'sv' => ['Swedish', ''],
      'sw' => ['Swahili', ''],
      'th' => ['Thai', ''],
      'tl' => ['Tagalog', ''],
      'tr' => ['Turkish', ''],
      'uk' => ['Ukrainian', ''],
      'ur' => ['Urdu', ''],
      'uz' => ['Uzbek', ''],
      'vi' => ['Vietnamese', ''],
      'wo' => ['Wolof', '']
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
