# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :site, :class => 'MomentumCms::Site' do
    label 'Test Site'
    host 'localhost:3000'
    available_locales ['en', 'fr']
  end
end