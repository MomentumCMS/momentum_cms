require_relative '../../../test_helper'

class MomentumCms::Admin::ContentsControllerTest < ActionController::TestCase

  def test_new
    site = momentum_cms_sites(:default)
    page = momentum_cms_pages(:default)
    get :new, site_id: site.id, page_id: page.id
    assert_response :success
    assert assigns(:momentum_cms_content)
  end

end
