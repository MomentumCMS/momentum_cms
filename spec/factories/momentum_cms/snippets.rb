FactoryGirl.define do
  factory :snippet, class: 'MomentumCms::Snippet' do
    site
    label 'Snippet'
    sequence(:identifier) { |n| "snippet_identifier_#{n}" }
  end
end
