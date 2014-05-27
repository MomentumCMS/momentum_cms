require 'test_helper'

class MomentumCms::Api::SessionsControllerTest < ActionController::TestCase

  def test_create
    # assert_difference "MomentumCms::ApiKey.count" do
      post :create, session: {
          email:       'fake',
          password:    'passpass',
          remember_me: '1'
          },
        format: :json
    # end
    assert_response 200
    api_key = MomentumCms::ApiKey.last
    # Currently just a canned response
    assert_equal 'admin@momentum-cms.io', json_response['user']['email']
    assert_equal api_key.access_token, json_response['user']['api_key']['access_token']
  end

end
