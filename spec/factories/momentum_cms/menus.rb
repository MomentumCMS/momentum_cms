FactoryGirl.define do
  factory :menu, class: 'MomentumCms::Menu' do
    site
    label 'Menu'
    sequence(:identifier) { |n| "menu_identifier_#{n}" }
  end
end
