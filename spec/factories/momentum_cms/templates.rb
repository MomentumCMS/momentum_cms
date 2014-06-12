FactoryGirl.define do
  factory :base_template_super_class, class: 'MomentumCms::Layout' do
    site
    label 'Base Template'
    sequence(:identifier) { |n| "base_template_identifier_#{n}" }
  end

  factory :base_template, parent: :base_template_super_class, class: 'MomentumCms::Template' do
    site
    label 'Base Template'
    sequence(:identifier) { |n| "base_template_identifier_#{n}" }

    factory :template do
      label 'Template'
      identifier 'template_identifier'
      value 'default {% cms_yield %}'
      js 'var default;'
      css '.default{}'
      has_yield true
    end

    factory :template_child do
      label 'Template Child'
      identifier 'template_child_identifier'
      value 'child'
      js 'var child;'
      css '.child{}'
      has_yield false
    end

  end
end