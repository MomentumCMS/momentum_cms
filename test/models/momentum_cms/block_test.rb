require 'test_helper'

class MomentumCms::BlockTest < ActiveSupport::TestCase

  def setup
    I18n.enforce_available_locales = false
    I18n.locale                    = :en
  end

  def test_fixture_validity
    MomentumCms::Block.all.each do |block|
      assert block.valid?
    end
  end

  def test_belongs_to_content
    content = momentum_cms_contents(:default)
    assert_difference "MomentumCms::Block.count" do
      block = content.blocks.create!(identifier: 'Block', value: '3')
      assert_equal block.content, content
    end
  end

  def test_translates_value
    block = momentum_cms_blocks(:default)
    assert block.value.blank?
    block.update_attribute(:value, 'Hello')
    I18n.locale = :fr
    block.update_attribute(:value, 'Bonjour')
    block.reload
    assert_equal 2, block.translations.length
    assert_equal 'Hello', block.translations.find_by(locale: 'en').value
    assert_equal 'Bonjour', block.translations.find_by(locale: 'fr').value
  end

end
