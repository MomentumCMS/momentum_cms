require_relative '../../test_helper'

class FixturePageTest < ActiveSupport::TestCase

  def setup
    I18n.locale = :en
    # Paths are always relative to the MomentumCms::config.site_fixtures_path
    @pages_path = File.join('example-a', 'pages')
    folder = SecureRandom.hex
    @site = MomentumCms::Site.create!(label: 'Import', host: 'localhost', identifier: folder)
  end

  def teardown
  end

  #== Importing =============================================================

  def test_basic_import
    assert_difference 'MomentumCms::Page.count', 8 do
      MomentumCms::Fixture::Template::Importer.new('example-a', @site).import!
      MomentumCms::Fixture::Page::Importer.new('example-a', @site).import!
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
    MomentumCms::Fixture::Template::Importer.new('example-a', @site).import!
    importer = MomentumCms::Fixture::Page::Importer.new('example-a', @site)
    page = momentum_cms_pages(:default)
    about_path = File.join(Rails.root, 'sites', 'example-a', 'pages', 'about')
      assert_difference "MomentumCms::Block.count", 4 do
        importer.prepare_content(page, about_path)
      end

    page.reload
    header = page.blocks.find_by(identifier: 'main-layout::header')
    content = page.blocks.find_by(identifier: 'main-layout::content')
    I18n.locale = 'en'
    assert_equal "Welcome", header.value.strip
    assert_equal "<p>Example English about content</p>", content.value.strip
    I18n.locale = :fr
    assert_equal "Bonjour", header.value.strip
    assert_equal "<p>Example French about content</p>", content.value.strip
  end

  def test_duplicate_import
    assert_difference "MomentumCms::Page.count", 8 do
      MomentumCms::Fixture::Template::Importer.new('example-a', @site).import!
      MomentumCms::Fixture::Page::Importer.new('example-a', @site).import!
      MomentumCms::Fixture::Page::Importer.new('example-a', @site).import!
    end
  end

  def test_multilingual_import
    @site.update_attributes! available_locales: [:en, :fr], default_locale: :en
    MomentumCms::Fixture::Template::Importer.new('multilingual-example', @site).import!
    MomentumCms::Fixture::Page::Importer.new('multilingual-example', @site).import!

    I18n.locale = :en
    home_en = @site.pages.roots.first
    assert_equal '/', home_en.path
    about_en = home_en.children.find_by(label: 'About')
    assert_equal 'About', about_en.label
    assert_equal '/about', about_en.path
    team_en = about_en.children.find_by(label: 'Team')
    assert_equal 'Team', team_en.label
    assert_equal '/about/team', team_en.path

    I18n.locale = :fr
    home_fr = @site.pages.roots.first.reload
    assert_equal '/', home_fr.path
    about_fr = home_fr.children.find_by(label: 'About')
    assert_equal 'About', about_fr.label
    assert_equal '/about-fr', about_fr.path
    team_fr = about_fr.children.find_by(label: 'Team')
    assert_equal 'Team', team_fr.label
    assert_equal '/about-fr/team-fr', team_fr.path
  end

  def test_slug_for_locale
    importer = MomentumCms::Fixture::Page::Importer.new('fake', nil)
    attributes = { 'label' => 'About', 'locales' => { 'en' => { 'slug' => 'about' }, 'fr' => { 'slug' => 'about-fr' } } }
    assert_equal 'about', importer.slug_for_locale(attributes, 'en')
    assert_equal 'about', importer.slug_for_locale(attributes, :en)
    assert_equal 'about-fr', importer.slug_for_locale(attributes, 'fr')
    assert_nil importer.slug_for_locale(attributes, 'es')
    simple_attributes = { 'label' => 'About', 'slug' => 'simple' }
    assert_equal 'simple', importer.slug_for_locale(simple_attributes)
  end

  #== Exporting =============================================================

  def test_basic_export
    MomentumCms::Fixture::Importer.new({ source: 'example-a', site: 'test' }).import!
    @site = MomentumCms::Site.where(identifier: 'test').first!
    folder = SecureRandom.hex
    MomentumCms::Fixture::Page::Exporter.new(folder, @site).export!
    test_export_path = File.join(MomentumCms::config.site_fixtures_path, folder, 'pages')
    assert File.exists?(File.join(test_export_path, 'attributes.json'))
    assert File.exists?(File.join(test_export_path, 'about', 'attributes.json'))
    assert File.exists?(File.join(test_export_path, 'about', 'portfolio', 'attributes.json'))
    assert File.exists?(File.join(test_export_path, 'about', 'portfolio', 'client-a', 'attributes.json'))
    assert File.exists?(File.join(test_export_path, 'about', 'team', 'attributes.json'))
    assert File.exists?(File.join(test_export_path, 'contact', 'attributes.json'))
    assert File.exists?(File.join(test_export_path, 'services', 'attributes.json'))
    assert File.exists?(File.join(test_export_path, 'services', 'about', 'attributes.json'))
    FileUtils.rm_rf(File.join(Rails.root, 'sites', folder))
  end

end
