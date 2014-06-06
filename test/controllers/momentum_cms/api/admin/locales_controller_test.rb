require 'test_helper'

class MomentumCms::Api::Admin::LocalesControllerTest < ActionController::TestCase

  def test_index
    get :index
    assert_response :success
    assert json_response['en'].present?
  end

end