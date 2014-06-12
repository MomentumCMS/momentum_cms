require_relative '../../../../rails_helper'

describe MomentumCms::Api::V1::SessionsController, type: :controller do
  context '#create' do
    it 'should create an access token' do
      expect {
        post :create,
             session: {
               email: 'fake',
               password: 'passpass',
               remember_me: '1'
             },
             format: :json
      }.to change { MomentumCms::ApiKey.count }.by(1)
      expect(response).to have_http_status(:ok)

      api_key = MomentumCms::ApiKey.last

      expect(json).to have_key('user')
      expect(json['user']['email']).to eq 'admin@momentum-cms.io'
      expect(json['user']['api_key']['access_token']).to eq api_key.access_token
    end
  end

  context '#destroy' do

  end


end
