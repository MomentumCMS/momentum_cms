FactoryGirl.define do
  factory :base_block, class: 'MomentumCms::Block' do
    page
    block_template
    sequence(:identifier) { |n| "base_block_identifier_#{n}" }

    factory :block do
      sequence(:identifier) { |n| "block_identifier_#{n}" }
    end

  end
end
