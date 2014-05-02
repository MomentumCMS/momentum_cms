require_relative '../test_helper'

class FixtureTest < ActiveSupport::TestCase

  def test_import_all
    MomentumCms::Site.destroy_all
    MomentumCms::Page.destroy_all
    assert_difference 'MomentumCms::Site.count' do
      assert_difference 'MomentumCms::Page.count' do
        MomentumCms::Fixture::Importer.new(from: 'example-a', to: 'example-import').import!
      end
    end
  end

end