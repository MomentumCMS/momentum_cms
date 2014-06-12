FactoryGirl.define do
  factory :site, :class => 'MomentumCms::Site' do
    label 'Test Site'
    host 'localhost:3000'
    available_locales ['en', 'fr']
    sequence(:identifier) { |n| "site_identifier_#{n}" }
  end
end