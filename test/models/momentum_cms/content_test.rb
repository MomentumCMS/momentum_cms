require_relative '../../test_helper'

class MomentumCms::ContentTest < ActiveSupport::TestCase
  def setup
    I18n.enforce_available_locales = false
    I18n.locale                    = :en
    @content                       = momentum_cms_contents(:default)
    @content.label                 = 'This is a content page label'
    @content.save
  end

  def test_fixture_validity
    MomentumCms::Content.all.each do |content|
      assert content.valid?
    end
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

  def test_default_content_scope
    content = MomentumCms::Content.default.first
    assert content.default
    MomentumCms::Content.update_all(default: false)
    assert MomentumCms::Content.default.blank?
    content.reload
    content.default = true
    content.save!
    assert MomentumCms::Content.default.length == 1
  end

  def test_published
    page = MomentumCms::Page.first
    page.update_attribute(:published_content_id, page.contents.first.id)
    content = page.published_content
    assert content.published?
    page.update_attribute(:published_content_id, nil)
    content.reload
    assert !content.published?
  end

  def test_default
    content = MomentumCms::Content.default.first
    assert content.default?
    content.update_attribute(:default, false)
    assert !content.default?
  end

end
