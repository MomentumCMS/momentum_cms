require_relative '../../rails_helper'

describe MomentumCms::Site, 'Model' do
  before(:each) do
    @site = create(:site)
  end

  context 'model' do
    it 'should have a valid factory' do
      expect(@site.valid?).to be true
    end

    it 'should have unique identifier' do
      expect { create(:site, identifier: 'foo') }.to change { MomentumCms::Site.count }.by(1)
      site = build(:site, identifier: 'foo')
      site.save
      expect(site.errors.include?(:identifier)).to be true
    end
  end

  context '#get_locales' do
    it 'should get the available locales' do
      expect(@site.get_locales).to eq(%w(en fr))
    end

    it 'should get the default configuration locale if there are no available locales' do
      @site.update_attributes(available_locales: [])
      expect(@site.get_locales).to eq([MomentumCms.configuration.locale.to_s])
    end
  end

  context '#assign_identifier' do
    it 'should assign identifier if one was not provided' do
      site = create(:site, identifier: nil)

      expect(site.identifier.present?).to be true
      expect(site.identifier.length > 1).to be true
    end
  end

  context '#locale_settings' do
    it 'should not allow default locale to be set without it being in the available locales' do
      @site.available_locales = [:en, :fr]
      @site.default_locale = :es
      @site.save
      expect(@site.errors.include?(:default_locale)).to be true
      expect(@site.errors[:default_locale]).to include('can not contain a locale that is not in the available locales list')
    end
  end
end

