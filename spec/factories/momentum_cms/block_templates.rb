FactoryGirl.define do
  factory :block_template, class: 'MomentumCms::BlockTemplate' do
    template
    sequence(:identifier) { |n| "block_template_identifier_#{n}" }
  end
end
