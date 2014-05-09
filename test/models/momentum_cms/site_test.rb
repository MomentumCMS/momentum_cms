require 'test_helper'

class MomentumCms::SiteTest < ActiveSupport::TestCase
  def test_fixture_validity
    MomentumCms::Site.all.each do |site|
      assert site.valid?
    end
  end

  def test_create
    assert_difference "MomentumCms::Site.count" do
      MomentumCms::Site.create(
        host: 'foo.host',
        label: 'Site Name',
        identifier: 'test'
      )
    end
  end
end
