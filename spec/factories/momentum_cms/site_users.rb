# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :site_user, class: 'MomentumCms::SiteUser' do
    site
#TODO How to do this factory thing for tableless models
  end
end
