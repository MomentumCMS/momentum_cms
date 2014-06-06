require_relative '../../rails_helper'

describe MomentumCms::Site, 'CRUD' do
  before(:each) do
    @site = create(:site)
  end

  it 'should have a valid factory' do
    expect(@site.valid?).to be true
  end
end

describe MomentumCms::Site, '#get_locales' do
  before(:each) do
    @site = FactoryGirl.create(:site)
  end

  it 'should get the available locales' do
    expect(@site.get_locales).to eq(%w(en fr))
  end

  it 'should get the default configuration locale if there are no available locales' do
    @site.update_attributes(available_locales: [])
    expect(@site.get_locales).to eq([MomentumCms.configuration.locale.to_s])
  end
end

describe MomentumCms::Site, '#locale_settings' do
  before(:each) do
    @site = FactoryGirl.create(:site)
  end

  it 'should not allow default locale to be set without it being in the available locales' do
    @site.available_locales = [:en, :fr]
    @site.default_locale = :es
    @site.save
    expect(@site.errors.include?(:default_locale)).to be true
    expect(@site.errors[:default_locale]).to include('can not contain a locale that is not in the available locales list')
  end
end