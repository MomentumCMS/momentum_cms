module MomentumCms
  module Fixture
    class Utils
      def self.each_locale_for_site(site, default_locale= [:en])
        original_locale = I18n.locale
        locales = site.get_locales(default_locale)
        locales.each do |locale|
          # Set the Locale
          I18n.locale = locale
          yield(locale)
        end
        I18n.locale = original_locale
      end

      def self.read_json(path, default = nil)
        ActiveSupport::JSON.decode(::File.read(path))
      rescue
        default
      end

      def self.read_file(path, default = nil)
        f = ''
        ::File.open(path, 'rb') do |f|
          f.read
        end
      rescue
        default || f
      end

      def self.write_json(path, data = {})
        self.write_file(path, JSON.pretty_generate(data))
      end

      def self.write_file(path, data)
        FileUtils.mkdir_p(::File.dirname(path))
        ::File.open(path, 'wb') do |f|
          f.write(data)
        end
      end

      def self.fresh_fixture?(object, file_path)
        object.new_record? || ::File.mtime(file_path) > object.updated_at
      end

    end
  end
end