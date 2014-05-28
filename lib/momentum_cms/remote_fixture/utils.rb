require 'open-uri'
module MomentumCms
  module RemoteFixture
    class Utils

      def self.each_locale_for_array(locales, default_locale= [:en])
        original_locale = I18n.locale
        locales.each do |locale|
          # Set the Locale
          begin
            I18n.locale = locale
            yield(locale)
          rescue I18n::InvalidLocale
          end
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