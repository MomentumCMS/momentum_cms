require_relative '../../test_helper'

class FixturePageTest < ActiveSupport::TestCase

  def setup
    # Paths are always relative to the MomentumCms::config.site_fixtures_path
    @pages_path = File.join('example-a', 'pages')
    @site = MomentumCms::Site.create(label: 'Import', host: 'localhost')
    # Ensure our example export site is removed before the tests are run
    @export_path = File.join('example-c', 'pages')
    @test_export_path = File.join(Rails.root, 'sites', 'example-c')
    FileUtils.rm_rf(@test_export_path) if File.exist?(@test_export_path)
  end

  def teardown
    FileUtils.rm_rf(@test_export_path)
  end

  #== Importing =============================================================

  def test_basic_import
    MomentumCms::Page.destroy_all
    assert_difference "MomentumCms::Page.count", 8 do
      MomentumCms::Fixture::Page::Importer.new(@site, @pages_path).import!
    end
    # Home Page
    home = @site.pages.roots.first
    assert_equal 'Home', home.label
    assert_equal '/', home.slug
    # About Page
    about = home.children.find_by(label: 'About')
    assert_equal 'about', about.slug
    # Portfolio Page
    portfolio = about.children.find_by(label: 'Portfolio')
    assert_equal 'portfolio', portfolio.slug
    # Portfolio Page
    team = about.children.find_by(label: 'Team')
    assert_equal 'team', team.slug
    # Client A Page
    client_a = portfolio.children.find_by(label: 'Client A')
    assert_equal 'client-a', client_a.slug
    # Contact Page
    contact = home.children.find_by(label: 'Contact')
    assert_equal 'contact', contact.slug
    # Services Page
    services = home.children.find_by(label: 'Services')
    assert_equal 'services', services.slug
    # Services About Page
    services_about = services.children.find_by(label: 'Services About')
    assert_equal 'about', services_about.slug
  end

  def test_prepare_content
    importer = MomentumCms::Fixture::Page::Importer.new(@site, @pages_path)
    page = momentum_cms_pages(:default)
    about_path = File.join(Rails.root, 'sites', 'example-a', 'pages', 'about')
    assert_difference "MomentumCms::Content.count", 1 do
      assert_difference "MomentumCms::Block.count", 2 do
        importer.prepare_content(page, about_path)
      end
    end
    page.reload
    header = page.contents.last.blocks.find_by(identifier: 'header')
    content = page.contents.last.blocks.find_by(identifier: 'content')
    I18n.locale = 'en'
    assert_equal "Welcome", header.value.strip
    assert_equal "<p>Example English about content</p>", content.value.strip
    I18n.locale = :fr
    assert_equal "Bonjour", header.value.strip
    assert_equal "<p>Example French about content</p>", content.value.strip
  end

  def test_duplicate_import
    MomentumCms::Page.destroy_all
    assert_difference "MomentumCms::Page.count", 8 do
      MomentumCms::Fixture::Page::Importer.new(@site, @pages_path).import!
      MomentumCms::Fixture::Page::Importer.new(@site, @pages_path).import!
    end
  end

  def test_generate_path
    pages = {}
    pages['/home/'] =                   {'label' => 'Home',   'slug' => '/'}
    pages['/home/about/'] =             {'label' => 'About',  'slug' => 'about'}
    pages['/home/about/team/'] =        {'label' => 'Team',   'slug' => 'team'}
    pages['/home/about/team/person/'] = {'label' => 'Person', 'slug' => 'person'}
    importer = MomentumCms::Fixture::Page::Importer.new(nil, 'fake')
    importer.pages_hash = pages
    path = importer.generate_path('/home/about/team/person', {'label' => 'Person', 'slug' => 'person'})
    assert_equal '/about/team/person', path
  end

  def test_ancestors
    pages = {}
    pages['/home/about/'] =             {'label' => 'About',  'slug' => 'about'}
    pages['/home/about/team/'] =        {'label' => 'Team',   'slug' => 'team'}
    pages['/home/about/team/person/'] = {'label' => 'Person', 'slug' => 'person'}
    importer = MomentumCms::Fixture::Page::Importer.new(nil, 'fake')
    importer.pages_hash = pages
    ancestors = importer.ancestors('/home/about/team/person')
    assert_equal 'Team', ancestors[0]['label']
    assert_equal 'About', ancestors[1]['label']
  end

  def test_has_parent
    pages = {}
    pages['/home/about/'] = {}
    pages['/home/about/team/'] = {}
    importer = MomentumCms::Fixture::Page::Importer.new(nil, 'fake')
    importer.pages_hash = pages
    assert importer.has_parent?('/home/about/team/')
    assert !importer.has_parent?('/home/about/')
  end

  def test_parent_path
    importer = MomentumCms::Fixture::Page::Importer.new(nil, 'fake')
    path = '/example/path'
    assert_equal '/example/', importer.parent_path(path)
    path = '/another/example/trailing-slash/'
    assert_equal '/another/example/', importer.parent_path(path)
  end

  def test_multilingual_generate_path
    pages = {}
    pages['/'] =                   {'label' => 'Home',   'slug' => '/'}
    pages['/about/'] =             {'label' => 'About',  'locales' => {'en' => {'slug' => 'about'},  'fr' => {'slug' => 'about-fr'}}}
    pages['/about/team/'] =        {'label' => 'Team',   'locales' => {'en' => {'slug' => 'team'},   'fr' => {'slug' => 'team-fr'}}}
    importer = MomentumCms::Fixture::Page::Importer.new(nil, 'fake')
    importer.pages_hash = pages
    path_en = importer.generate_path('/about/team/person', {'label' => 'Person', 'slug' => 'person'}, 'en')
    path_fr = importer.generate_path('/about/team/person', {'label' => 'Person', 'slug' => 'person'}, 'fr')
    assert_equal '/about/team/person', path_en
    assert_equal '/about-fr/team-fr/person', path_fr
  end

  def test_multilingual_import
    importer = MomentumCms::Fixture::Page::Importer.new(@site, File.join('multilingual-example', 'pages')).import!
  end

  def test_slug_for_locale
    importer = MomentumCms::Fixture::Page::Importer.new(nil, 'fake')
    attributes = {'label' => 'About',  'locales' => {'en' => {'slug' => 'about'},  'fr' => {'slug' => 'about-fr'}}}
    assert_equal 'about', importer.slug_for_locale(attributes, 'en')
    assert_equal 'about-fr', importer.slug_for_locale(attributes, 'fr')
    assert_nil importer.slug_for_locale(attributes, 'es')
    simple_attributes = {'label' => 'About',  'slug' => 'simple'}
    assert_equal 'simple', importer.slug_for_locale(simple_attributes)
  end

  #== Exporting =============================================================

  def test_basic_export
    MomentumCms::Fixture::Page::Importer.new(@site, @pages_path).import!
    page_tree = @site.pages.arrange
    export_path = File.join('example-c', 'pages')
    MomentumCms::Fixture::Page::Exporter.new(page_tree, export_path).export!
    test_export_path = File.join(MomentumCms::config.site_fixtures_path, export_path)
    assert File.exists?(File.join(test_export_path, 'attributes.json'))
    assert File.exists?(File.join(test_export_path, 'about', 'attributes.json'))
    assert File.exists?(File.join(test_export_path, 'about', 'portfolio', 'attributes.json'))
    assert File.exists?(File.join(test_export_path, 'about', 'portfolio', 'client-a', 'attributes.json'))
    assert File.exists?(File.join(test_export_path, 'about', 'team', 'attributes.json'))
    assert File.exists?(File.join(test_export_path, 'contact', 'attributes.json'))
    assert File.exists?(File.join(test_export_path, 'services', 'attributes.json'))
    assert File.exists?(File.join(test_export_path, 'services', 'about', 'attributes.json'))
  end

end