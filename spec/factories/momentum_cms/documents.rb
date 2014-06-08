FactoryGirl.define do
  factory :base_document, class: 'MomentumCms::Document' do
    site
    blue_print
    sequence(:identifier) { |n| "base_document_identifier_#{n}" }
    layout { blue_print }

    factory :document do
      identifier 'document_identifier'
    end

    factory :document_child do
      identifier 'document_child_identifier'
    end
  end
end
