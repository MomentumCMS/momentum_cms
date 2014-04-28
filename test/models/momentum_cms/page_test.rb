require 'test_helper'

class MomentumCms::PageTest < ActiveSupport::TestCase

  def setup
    I18n.enforce_available_locales = false
    I18n.locale = :en
    page      = momentum_cms_pages(:default)
    page.slug = 'default'
    page.save
  end

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
    page = momentum_cms_pages(:default)
    assert_equal :en, I18n.locale
    assert_equal 'default', page.slug
    assert_equal '/default', page.path
    I18n.locale = :fr
    page.slug = 'le-test'
    page.path = '/le-test'
    assert_equal 'le-test', page.slug
    assert_equal '/le-test', page.path
    I18n.locale = :en
    assert_equal 'default', page.slug
    assert_equal '/default', page.path
  end

  def test_assigns_path
    page = MomentumCms::Page.create(
      site:  momentum_cms_sites(:default),
      label: 'About',
      slug:  'about'
    )
    assert !page.new_record?
    assert_equal '/about', page.path
  end

  def test_assigns_nested_path
    page = momentum_cms_pages(:default)
    child = MomentumCms::Page.create(
      site:   momentum_cms_sites(:default),
      label:  'Child',
      slug:   'child',
      parent: page
    )
    grandchild = MomentumCms::Page.create(
      site:   momentum_cms_sites(:default),
      label:  'Grandchild',
      slug:   'grandchild',
      parent: child
    )
    assert_equal '/default/child', child.path
    assert_equal '/default/child/grandchild', grandchild.path
  end

  def test_assigns_correct_translation_paths
    assert_equal :en, I18n.locale
    page  = momentum_cms_pages(:default)
    child = MomentumCms::Page.create(
      site:   momentum_cms_sites(:default),
      label:  'Child-en',
      slug:   'child-en',
      parent: page
    )

    child.label = 'Child-en'
    child.slug  = 'child-en'
    child.save

    grandchild = MomentumCms::Page.create(
      site:   momentum_cms_sites(:default),
      label:  'Grandchild-en',
      slug:   'grandchild-en',
      parent: child
    )
    assert_equal '/default/child-en/grandchild-en', grandchild.path
    I18n.locale = :fr
    page.update_attributes(slug: 'default-fr')
    child.reload
    grandchild.reload    
    
    assert_equal '/default-fr', page.path
    assert_equal '/default-fr/child-en', child.path
    assert_equal '/default-fr/child-en/grandchild-en', grandchild.path
    child.update_attributes(slug: 'child-fr')
    child.reload
    grandchild.reload
    assert_equal '/default-fr/child-fr', child.path
    assert_equal '/default-fr/child-fr/grandchild-en', grandchild.path
    child.update_attributes(slug: 'child-fr')
    grandchild.update_attributes(slug: 'grandchild-fr')
    assert_equal '/default-fr/child-fr/grandchild-fr', grandchild.path
    assert_equal '/default-fr/child-fr', child.path
    I18n.locale = :en
    assert_equal '/default/child-en/grandchild-en', grandchild.path
  end

  def test_assigns_fallback_slugs_to_path_when_required
    page  = momentum_cms_pages(:default)
    child = MomentumCms::Page.create(
      site:   momentum_cms_sites(:default),
      label:  'Child-en',
      slug:   'child-en',
      parent: page
    )
    grandchild = MomentumCms::Page.create(
      site:   momentum_cms_sites(:default),
      label:  'Grandchild-en',
      slug:   'grandchild-en',
      parent: child
    )
    I18n.locale = :fr
    page.update_attributes(slug: 'default-fr')
    grandchild.update_attributes(slug: 'grandchild-fr')
    assert_equal '/default-fr', page.path
    assert_equal '/default-fr/child-en/grandchild-fr', grandchild.path
  end

  def test_regnerates_paths_of_child_pages
    page  = momentum_cms_pages(:default)
    child = MomentumCms::Page.create(
      site:   momentum_cms_sites(:default),
      label:  'Child-en',
      slug:   'child-en',
      parent: page
    )
    grandchild = MomentumCms::Page.create(
      site:   momentum_cms_sites(:default),
      label:  'Grandchild-en',
      slug:   'grandchild-en',
      parent: child
    )
    assert_equal '/default/child-en/grandchild-en', grandchild.path
    child.update_attributes(slug: 'new-slug')

    assert_equal '/default/new-slug', child.path
    assert_equal 'new-slug', child.slug

    grandchild.update_attributes(slug: 'new-grandchild-slug')    
    assert_equal '/default/new-slug/new-grandchild-slug', grandchild.path
    
    child.update_attributes(slug: 'another-slug')

    assert_equal '/default/another-slug', child.path
    assert_equal 'another-slug', child.slug

    grandchild.reload
    
    assert_equal '/default/another-slug/new-grandchild-slug', grandchild.path    
  end

end
