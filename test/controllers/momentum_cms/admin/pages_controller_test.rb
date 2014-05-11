require 'test_helper'

class MomentumCms::Admin::PagesControllerTest < ActionController::TestCase

  def test_new
    get :new, site_id: momentum_cms_sites(:default).id
    assert_response :success
  end

end
