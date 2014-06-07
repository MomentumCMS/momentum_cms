require_relative '../../rails_helper'

describe MomentumCms::Block, 'Model' do
  before(:each) do
    @block = create(:block)
  end

  context 'model' do
    it 'should have a valid factory' do
      expect(@block.valid?).to be true
    end

    it 'should belong to page' do
      page = create(:page)
      block_template = create(:block_template)
      block = page.blocks.create!(identifier: 'Block', value: '3', block_template: block_template)
      expect(block.page).to eq(page)
    end
  end

  context '.value' do
    it 'should allow translated value' do
      I18n.locale = :en
      expect(@block.value.blank?).to be true
      @block.update_attribute(:value, 'Hello')
      I18n.locale = :fr
      @block.update_attribute(:value, 'Bonjour')
      expect(@block.translations.length == 2).to be true
      expect(@block.translations.find_by(locale: 'en').value).to eq('Hello')
      expect(@block.translations.find_by(locale: 'fr').value).to eq('Bonjour')
    end
  end

  context '.draft_blocks' do
    it 'should return only draft blocks' do
      expect(MomentumCms::Block.draft_blocks).to include(@block)
    end
  end

  context '.published_blocks' do
    it 'should return only published blocks' do
      expect(MomentumCms::Block.published_blocks).to include(@block.revision_block)
    end
  end

  context '#draft?' do
    it 'should respond to draft' do
      expect(@block.draft?).to be true
    end
  end

  context '#published?' do
    it 'should respond to published' do
      expect(@block.revision_block.published?).to be true
      expect(@block.published?).to be false
    end
  end

  context '#create_revision_block' do
    it 'should create revision block' do
      expect { create(:block) }.to change { MomentumCms::Block.count }.by(2)
    end
  end

  context '#destroy_revision_block' do
    it 'should destroy revision block' do
      expect { @block.destroy }.to change { MomentumCms::Block.count }.by(-2)
    end
  end
end