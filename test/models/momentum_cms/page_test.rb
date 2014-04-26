require 'test_helper'

class MomentumCms::PageTest < ActiveSupport::TestCase

  def test_fixture_validity
    MomentumCms::Page.all.each do |page|
      assert page.valid?
    end
  end

  def test_create
    assert_difference "MomentumCms::Page.count" do
      page = MomentumCms::Page.create(
        site:  momentum_cms_sites(:default),
        label: 'About',
        slug:  'about'
      )
    end
  end

end
