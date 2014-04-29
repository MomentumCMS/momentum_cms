require 'json'

class MomentumCms::Fixture

  class Importer
  end

  class Exporter
  end

  class Utils

    def self.read_json(path)
      ActiveSupport::JSON.decode(File.read(path))
    end

    def self.write_json(path, data = {})
      File.open(path, 'w') do |f|
        f.write(data.to_json)
      end
    end

  end

end