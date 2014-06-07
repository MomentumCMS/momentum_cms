require_relative '../../test_helper'

class MomentumCms::TemplateTest < ActiveSupport::TestCase


  def test_block_template_create_or_update
    template = nil
    assert_difference 'MomentumCms::BlockTemplate.count', 2 do
      template = MomentumCms::Template.create!(
          site: momentum_cms_sites(:default),
          label: 'About',
          identifier: 'about',
          value: '{% cms_block id:foo type:string %} {% cms_block id:bar type:string %}'
      )
    end

    assert_no_difference 'MomentumCms::BlockTemplate.count' do
      template.value = '{% cms_block id:foo type:string %} {% cms_block id:baz type:string %}'
      template.save!
    end

    assert_difference 'MomentumCms::BlockTemplate.count', -2 do
      template.value = 'hi'
      template.save!
    end
  end


  def test_create
    assert_difference "MomentumCms::Template.count" do
      MomentumCms::Template.create(
          site: momentum_cms_sites(:default),
          label: 'About',
          identifier: 'about'
      )
    end
  end

  def test_same_label_scoped_to_same_site
    assert_difference "MomentumCms::Template.count" do
      MomentumCms::Template.create(
          site: momentum_cms_sites(:default),
          label: 'About',
          identifier: 'about'
      )
      template = MomentumCms::Template.create(
          site: momentum_cms_sites(:default),
          label: 'About',
          identifier: 'about'
      )
      refute template.valid?
    end
  end

  def test_same_label_scoped_to_different_sites
    assert_difference "MomentumCms::Template.count", 2 do
      MomentumCms::Template.create(
          site: momentum_cms_sites(:default),
          label: 'About',
          identifier: 'about'
      )
      MomentumCms::Template.create(
          site: momentum_cms_sites(:alternative),
          label: 'About',
          identifier: 'about'
      )
    end
  end


  def test_permanent_record
    assert @child.destroy

    refute @parent.permanent_record

    @parent.permanent_record = true
    @parent.save!

    assert @parent.permanent_record

    assert_no_difference 'MomentumCms::Template.count' do
      assert_raise MomentumCms::PermanentObject do
        @parent.destroy
      end
    end

    assert @parent.persisted?
  end
end
