module MomentumCms
  module RemoteFixture

    class Importer

      def initialize(options = {})
        raise ArgumentError.new('Expecting options to be a hash') unless options.is_a?(Hash)
        @source = options.fetch(:source, nil)
        raise ArgumentError.new('Expecting :source to be passed from the options') if @source.blank?
        @site = options.fetch(:site, nil)
        if @site.nil? || !@site.is_a?(MomentumCms::Site)
          site_identifier = options.fetch(:site_id, nil)
          @site = MomentumCms::Site.where(identifier: site_identifier).first
        end
        raise ArgumentError.new('Expecting :site or :site_id to be passed from the options') if @site.blank? || !@site.is_a?(MomentumCms::Site)
      end

      def import!
        blue_print = MomentumCms::RemoteFixture::BluePrint::Importer.new(@source, @site).import!
        document = MomentumCms::RemoteFixture::Document::Importer.new(@source, @site).import!
      end
    end

  end
end