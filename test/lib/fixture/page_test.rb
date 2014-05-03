require_relative '../../test_helper'

class FixturePageTest < ActiveSupport::TestCase

  def setup
    # Paths are always relative to the MomentumCms::config.site_fixtures_path
    @pages_path = File.join('example-a', 'pages')
    @site = MomentumCms::Site.create(label: 'Import', host: 'localhost')
  end

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

end