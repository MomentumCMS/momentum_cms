module MomentumCms
  module RemoteFixture
    module Base
      class Importer
        attr_accessor :site
        attr_accessor :remote_fixture_url
        attr_accessor :remote_fixture_object

        def initialize(remote_fixture_url, site)
          @remote_fixture_url = remote_fixture_url
          @site = site
          @remote_fixture_object = MomentumCms::RemoteFixture::Utils.read_remote_json(remote_fixture_url)
        end

        def import!
        end
      end
    end
  end
end
