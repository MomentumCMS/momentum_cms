require_relative '../../../../../rails_helper'

describe MomentumCms::Api::V1::Admin::LocalesController, type: :controller do
  context '#index' do
    it 'should get a list of available locales' do
      get :index
      expect(json).to have_key('en')
      expect(response).to have_http_status(:success)
    end
  end
end
