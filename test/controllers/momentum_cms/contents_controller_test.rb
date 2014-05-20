require_relative '../../test_helper'

class MomentumCms::ContentsControllerTest < ActionController::TestCase

  def setup
    @site = momentum_cms_sites(:default)
    @page = momentum_cms_pages(:default)
    @page.update_attribute(:published_content_id, @page.contents.first.id)
  end

  def test_show
    # TODO: Fix error: A template needs to have a virtual path in order to be refreshed
    # get :show
    # assert_response :success
  end

end
