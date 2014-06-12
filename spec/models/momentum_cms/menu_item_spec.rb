require_relative '../../rails_helper'

describe MomentumCms::MenuItem, 'Model' do
  before(:each) do
    @menu_item = create(:menu_item)
  end

  context 'model' do
    it 'should have a valid factory' do
      expect(@menu_item.valid?).to be true
    end
  end

  context '#assign_menu_item_type' do
    it 'should assign the proper INTERNAL item type' do
      @menu_item.linkable = create(:page)
      @menu_item.save
      expect(@menu_item.menu_item_type).to be MomentumCms::MenuItem::INTERNAL
    end

    it 'should assign the proper EXTERNAL item type' do
      @menu_item = create(:menu_item, linkable: nil)
      expect(@menu_item.menu_item_type).to be MomentumCms::MenuItem::EXTERNAL
    end
  end

  context '.external' do
    it 'should only return external menu items' do
      @menu_item = create(:menu_item, linkable: nil)
      expect(MomentumCms::MenuItem.external).to include(@menu_item)
    end
  end

  context '.internal' do
    it 'should only return internal menu items' do
      @menu_item = create(:menu_item, linkable: create(:page))
      expect(MomentumCms::MenuItem.internal).to include(@menu_item)
    end
  end
end
