module MomentumCms::Fixture

  class Importer

    def initialize(options = {})
      @from = options[:from]
      raise ArgumentError.new('Expecting :from to be passed from the options') if @from.blank?
    end

    def import!
      site = MomentumCms::Fixture::Site::Importer.new(@from).import!
      MomentumCms::Fixture::Template::Importer.new(@from, site).import!
      MomentumCms::Fixture::Page::Importer.new(@from, site).import!
    end

  end

  class Exporter

    def initialize(options = {})
    end

    def export!
    end

  end

end