module MomentumCms::Fixture

  class Utils

    def self.read_json(path)
      ActiveSupport::JSON.decode(File.read(path))
    end

    def self.write_json(path, data = {})
      File.open(path, 'w') do |f|
        f.write(JSON.pretty_generate(data))
      end
    end

  end

end