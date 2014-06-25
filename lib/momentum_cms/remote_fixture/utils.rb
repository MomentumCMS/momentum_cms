require 'open-uri'
module MomentumCms
  module RemoteFixture
    class Utils
      def self.import_localized_object(object, site)
        original_locale = I18n.locale
        case object
          when Hash
            object.each do |locale, value|
              begin
                I18n.locale = locale
                yield(value, locale)
              rescue I18n::InvalidLocale
              end
            end

          when String
            I18n.locale = site.default_locale
            yield(object, I18n.locale)
        end
        I18n.locale = original_locale
      end

      def self.read_remote_json(path, default = nil)
        ActiveSupport::JSON.decode(open(path).read)
      rescue
        default
      end

      def self.read_remote_file(path, default = nil)
        f = open(path).read
      rescue
        default || f
      end
    end
  end
end