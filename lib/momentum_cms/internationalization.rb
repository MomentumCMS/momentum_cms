module MomentumCms
  class Internationalization
    @@lookup = {
      'en' => 'English',
      'fr' => 'Français',
      'es' => 'Spanish' #TODO
    }

    def self.lookup(locale)
      locale = locale.to_s
      if @@lookup.has_key?(locale)
        @@lookup[locale]
      else
        locale
      end
    end

    def self.register(locale, label)
      locale = locale.to_s
      if lookup(locale) == locale
        @@lookup[locale] = label
      end
    end

  end
end
