FactoryGirl.define do
  factory :api_key, class: 'MomentumCms::ApiKey' do
    scope 'session'
    user_id nil
    created_at { 4.years.ago }
  end
end
