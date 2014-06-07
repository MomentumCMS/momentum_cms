FactoryGirl.define do
  factory :api_key, class: 'MomentumCms::ApiKey' do
    scope 'session'
  end
end
