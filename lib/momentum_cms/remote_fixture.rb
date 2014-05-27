module MomentumCms
  module RemoteFixture

    class Importer

      def initialize(options = {})
        raise ArgumentError.new('Expecting options to be a hash') unless options.is_a?(Hash)
        @source = options.fetch(:source, nil)
        raise ArgumentError.new('Expecting :source to be passed from the options') if @source.blank?
        @site = options.fetch(:site, nil)
        raise ArgumentError.new('Expecting :site to be passed from the options') if @site.blank? || !@site.is_a?(MomentumCms::Site)
      end

      def import!
        document_template = MomentumCms::RemoteFixture::DocumentTemplate::Importer.new(@source, @site).import!
      end
    end

  end
end