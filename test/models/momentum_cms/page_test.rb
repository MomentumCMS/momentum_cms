require 'test_helper'

class MomentumCms::PageTest < ActiveSupport::TestCase

  def test_fixture_validity
    MomentumCms::Page.all.each do |page|
      assert page.valid?
    end
  end

  def test_create
    assert_difference "MomentumCms::Page.count" do
      page = MomentumCms::Page.create(
        site:  momentum_cms_sites(:default),
        label: 'About',
        slug:  'about'
      )
    end
  end

  def test_translates_path_and_locale
    I18n.enforce_available_locales = false
    page = momentum_cms_pages(:default)
    assert_equal :en, I18n.locale
    assert_equal 'default', page.slug
    assert_equal '/default', page.path
    I18n.locale = :fr
    page.slug = 'le-test'
    assert_equal 'le-test', page.slug
    I18n.locale = :en
    assert_equal 'default', page.slug
  end

  def test_assigns_path
    page = MomentumCms::Page.create(
      site:  momentum_cms_sites(:default),
      label: 'About',
      slug:  'about'
    )
    assert_equal '/about', page.path
  end

end
