FactoryGirl.define do
  factory :base_page, class: 'MomentumCms::Page' do
    site
    template
    slug 'base_page'
    sequence(:identifier) { |n| "base_page_identifier_#{n}" }

    factory :page do
      slug 'page'
      identifier 'page_identifier'
    end

    factory :page_child do
      slug 'page_child'
      identifier 'page_child_identifier'
    end
  end
end
