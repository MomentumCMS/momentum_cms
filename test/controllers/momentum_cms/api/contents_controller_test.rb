require_relative '../../../test_helper'

class MomentumCms::Api::ContentsControllerTest < ActionController::TestCase

  def setup
    setup_test_site
  end

  def test_show
    get :show, id: '/', format: :json
    assert assigns(:momentum_cms_site)
    # Content Attributes
    assert json_response['content']['id'].present?
    # Page Attributes
    assert_equal '/', json_response['content']['page']['slug']
    # Site Attributes
    assert_equal 'MomentumCMS', json_response['content']['site']['title']
  end

end