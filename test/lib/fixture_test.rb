require_relative '../test_helper'

class FixtureTest < ActiveSupport::TestCase

  def test_import_all
    assert_difference 'MomentumCms::Site.count' do
      assert_difference 'MomentumCms::Page.count', 8 do
        MomentumCms::Fixture::Importer.new(from: 'example-a', to: 'new_test').import!
      end
    end
  end

end