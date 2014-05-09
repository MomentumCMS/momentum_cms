module MomentumCms
  module Fixture

    class Importer

      def initialize(options = {})
        raise ArgumentError.new('Expecting options to be a hash') unless options.is_a?(Hash)
        @from = options.fetch(:from, nil)
        raise ArgumentError.new('Expecting :from to be passed from the options') if @from.blank?
        @to = options.fetch(:to, nil)
      end

      def import!
        site = MomentumCms::Fixture::Site::Importer.new(@from, @to).import!
        templates = MomentumCms::Fixture::Template::Importer.new(@from, site).import!
        pages = MomentumCms::Fixture::Page::Importer.new(@from, site).import!
      end
    end

    class Exporter
      
      def initialize(options = {})
      end

      def export!
      end
    end
  end
end