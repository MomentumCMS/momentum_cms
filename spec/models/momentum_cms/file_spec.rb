require_relative '../../rails_helper'

describe MomentumCms::File, 'Model' do
  before(:each) do
    @file = create(:file)
  end

  context 'model' do
    it 'should have a valid factory' do
      expect(@file.valid?).to be true
    end

    it 'should have unique identifier' do
      site = create(:site)
      expect { create(:file, identifier: 'foo', site: site) }.to change { MomentumCms::File.count }.by(1)
      site = build(:file, identifier: 'foo', site: site)
      site.save
      expect(site.errors.include?(:identifier)).to be true
    end
  end
end
