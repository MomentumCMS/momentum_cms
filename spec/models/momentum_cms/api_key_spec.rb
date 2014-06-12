require_relative '../../rails_helper'

describe MomentumCms::ApiKey, 'Model' do
  before(:each) do
    @api_key = create(:api_key)
  end

  context 'model' do
    it 'should have a valid factory' do
      expect(@api_key.valid?).to be true
    end
  end

  context '#generate_access_token' do
    it 'should generate access token' do
      @api_key = create(:api_key, access_token: nil)
      expect(@api_key.access_token.present?).to be true
    end
  end

  context '#set_expiry_date' do
    it 'should set the expiry date for api' do
      @api_key = create(:api_key, scope: 'api')
      expect(@api_key.expired_at.to_i).to eq(30.days.from_now.to_i)
    end

    it 'should set the expiry date for session' do
      @api_key = create(:api_key, scope: 'session')
      expect(@api_key.expired_at.to_i).to eq(4.hours.from_now.to_i)
    end
  end
end
