FactoryGirl.define do
  factory :link, class: 'MomentumCms::Link' do
    site
    sequence(:identifier) { |n| "link_identifier_#{n}" }
  end
end
