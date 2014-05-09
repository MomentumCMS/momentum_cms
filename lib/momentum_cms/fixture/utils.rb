module MomentumCms
  module Fixture
    class Utils

      def self.read_json(path, default = nil)
        ActiveSupport::JSON.decode(::File.read(path))
      rescue
        default
      end

      def self.read_file(path, default = nil)
        f = ''
        ::File.open(path, "rb") do |f|
          f.read
        end
      rescue
        default || f
      end

      def self.write_json(path, data = {})
        self.write_file(path, JSON.pretty_generate(data))
      end

      def self.write_file(path, data)
        ::File.open(path, 'w') do |f|
          f.write(data)
        end
      end

      def self.fresh_fixture?(object, file_path)
        object.new_record? || ::File.mtime(file_path) > object.updated_at
      end

    end
  end
end