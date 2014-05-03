module MomentumCms::Fixture

  class Importer

    def initialize(options = {})
      @from = options[:from]
    end

    def import!
      site = MomentumCms::Fixture::Site::Importer.new(@from).import!
      MomentumCms::Fixture::Page::Importer.new(@from, File.join(@from, 'pages')).import!
    end

  end

  class Exporter

    def initialize(options = {})
    end

    def export!
    end

  end

end