FactoryGirl.define do
  factory :base_layout, class: 'MomentumCms::Layout' do
    site
    label 'Base Layout'
    sequence(:identifier) { |n| "base_layout_identifier_#{n}" }

    factory :layout do
      label 'Layout'
      identifier 'layout_identifier'
    end

    factory :layout_child do
      label 'Layout Child'
      identifier 'layout_child_identifier'
    end
  end
end
