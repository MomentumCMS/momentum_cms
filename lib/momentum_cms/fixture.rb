module MomentumCms
  module Fixture

    class Importer

      def initialize(options = {})
        raise ArgumentError.new('Expecting options to be a hash') unless options.is_a?(Hash)
        @source = options.fetch(:source, nil)
        raise ArgumentError.new('Expecting :source to be passed from the options') if @source.blank?
        @site = options.fetch(:site, nil)
      end

      def import!
        site = MomentumCms::Fixture::Site::Importer.new(@source, @site).import!
        templates = MomentumCms::Fixture::Template::Importer.new(@source, site).import!
        pages = MomentumCms::Fixture::Page::Importer.new(@source, site).import!
      end
    end

    class Exporter

      def initialize(options = {})
        site_identifier = options.fetch(:site, nil)
        @site = MomentumCms::Site.where(identifier: site_identifier).first
        raise StandardError.new('Expecting site identifier to point to a valid site.') unless @site
        @target = options.fetch(:target, nil)
      end

      def export!
        MomentumCms::Fixture::Site::Exporter.new(@target, @site).export!
        MomentumCms::Fixture::Template::Exporter.new(@target, @site).export!
        MomentumCms::Fixture::Page::Exporter.new(@target, @site).export!
      end
    end
  end
end