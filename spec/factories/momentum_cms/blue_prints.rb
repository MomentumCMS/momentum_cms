FactoryGirl.define do

  factory :base_blue_print_super_class, class: 'MomentumCms::Layout' do
    site
    label 'Base Blue Print'
    sequence(:identifier) { |n| "base_blue_print_identifier_#{n}" }
  end

  factory :base_blue_print, parent: :base_blue_print_super_class, class: 'MomentumCms::BluePrint' do

    site
    label 'Base Blue Print'
    sequence(:identifier) { |n| "base_blue_print_identifier_#{n}" }

    factory :blue_print do
      label 'BluePrint'
      identifier 'blue_print_identifier'
    end

    factory :blue_print_child do
      label 'BluePrint Child'
      identifier 'blue_print_child_identifier'
    end
  end
end
