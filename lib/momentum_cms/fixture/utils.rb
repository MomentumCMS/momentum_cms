module MomentumCms::Fixture

  class Utils

    def self.read_json(path)
      ActiveSupport::JSON.decode(File.read(path))
    end

    def self.read_file(path)
      f = ''
      File.open(path, "rb") do |f|
        f.read
      end
    rescue
      f
    end

    def self.write_json(path, data = {})
      File.open(path, 'w') do |f|
        f.write(JSON.pretty_generate(data))
      end
    end

    def self.fresh_fixture?(object, file_path)
      object.new_record? || ::File.mtime(file_path) > object.updated_at
    end

  end

end