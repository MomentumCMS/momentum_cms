FactoryGirl.define do
  factory :file, class: 'MomentumCms::File' do
    site
    sequence(:identifier) { |n| "file_identifier_#{n}" }
  end
end
