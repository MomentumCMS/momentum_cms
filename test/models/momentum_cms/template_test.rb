require 'test_helper'

class MomentumCms::TemplateTest < ActiveSupport::TestCase
  def test_fixture_validity
    MomentumCms::Template.all.each do |template|
      assert template.valid?
    end
  end

  def test_create
    assert_difference "MomentumCms::Template.count" do
      template = MomentumCms::Template.create(
        site:  momentum_cms_sites(:default),
        label: 'About'
      )
    end
  end

  def test_same_label_scoped_to_same_site
    assert_difference "MomentumCms::Template.count" do
      MomentumCms::Template.create(
        site:  momentum_cms_sites(:default),
        label: 'About'
      )
      template = MomentumCms::Template.create(
        site:  momentum_cms_sites(:default),
        label: 'About'
      )
      refute template.valid?
    end
  end

  def test_same_label_scoped_to_different_sites
    assert_difference "MomentumCms::Template.count", 2 do
      MomentumCms::Template.create(
        site:  momentum_cms_sites(:default),
        label: 'About'
      )
      MomentumCms::Template.create(
        site:  momentum_cms_sites(:alternative),
        label: 'About'
      )
    end
  end

  def test_ensure_valid_content
    template = MomentumCms::Template.create(
      site:    momentum_cms_sites(:default),
      label:   'About',
      content: '{{notvalidliquid'
    )
    refute template.valid?
  end

end
