require_relative '../../rails_helper'

describe MomentumCms::Menu do
  before(:each) do
    @menu = create(:menu)
  end

  context 'model' do
    it 'should have a valid factory' do
      expect(@menu.valid?).to be true
    end

    it 'should have unique identifier' do
      site = create(:site)
      expect { create(:menu, identifier: 'foo', site: site) }.to change { MomentumCms::Menu.count }.by(1)
      site = build(:menu, identifier: 'foo', site: site)
      site.save
      expect(site.errors.include?(:identifier)).to be true
    end
  end

  context '#update_menu_items' do
    it 'should create menu items from the json' do
      page = create(:page)
      @menu.menu_json = "[{\"id\":\"#{page.id}\",\"label\":\"#{page.label}\"}]"
      expect { @menu.save }.to change { MomentumCms::MenuItem.count }.by(1)
    end
  end
end
