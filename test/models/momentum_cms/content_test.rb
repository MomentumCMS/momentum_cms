require_relative '../../test_helper'

class MomentumCms::ContentTest < ActiveSupport::TestCase
  def setup
    I18n.enforce_available_locales = false
    I18n.locale                    = :en
    @content                       = momentum_cms_contents(:default)
    @content.label                 = 'This is a content page label'
    @content.content               = 'This is a content page content'
    @content.save
  end

  def test_defaults
    assert_equal @content.label, 'This is a content page label'
    assert_equal 1, @content.translation.versions.length

    @content.label = 'New Label'
    @content.save
    assert_equal 2, @content.translation.versions.length
    assert_equal 2, @content.versions.length

    I18n.locale = :fr

    @content.label = 'Le New Label'
    @content.save
    assert_equal 1, @content.translation.versions.length
    assert_equal 3, @content.versions.length
  end

  def test_validates_unique_default
    page = momentum_cms_pages(:default)
    assert page.contents.find_by(default: true)
    content = page.contents.build(default: true, label: 'Duplicate Default')
    assert !content.valid?
  end

  def test_default_content_scope
    content = MomentumCms::Content.default.first
    assert content.default
    assert_difference 'MomentumCms::Content.default.count', -1 do
      content.update_attribute(:default, false)
    end
  end

  def test_published
    content = MomentumCms::Content.default.first
    page = content.page
    assert !content.published?
    page.update_attribute(:published_content_id, content.id)
    assert content.published?
  end

  def test_default
    content = MomentumCms::Content.default.first
    assert content.default?
    content.update_attribute(:default, false)
    assert !content.default?
  end

end
