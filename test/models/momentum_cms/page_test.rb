require 'test_helper'

class MomentumCms::PageTest < ActiveSupport::TestCase

  def test_fixture_validity
    MomentumCms::Page.all.each do |page|
      assert page.valid?
    end
  end

  def test_create
    # page = MomentumCms::Page.create()
  end

end
