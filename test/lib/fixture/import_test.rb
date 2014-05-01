require_relative '../../test_helper'

class FixtureImportTest < ActiveSupport::TestCase

  def setup
    @path = File.join(Rails.root, 'sites', 'example-a', 'attributes.json')
  end

  def test_basic_site_import
    assert_difference "MomentumCms::Site.count" do
      MomentumCms::Fixture::Import.site(@path)
    end
    site = MomentumCms::Site.find_by(label: 'Example A')
    assert_equal 'example-a.dev', site.host
  end

  def test_basic_page_tree_import
    MomentumCms::Page.destroy_all
    assert_difference "MomentumCms::Page.count", 4 do
      MomentumCms::Fixture::Import.site(@path)
    end
    # Home Page
    home = MomentumCms::Page.roots.first
    assert_equal 'Home', home.label
    assert_equal '/', home.slug
    # About Page
    about = home.children.find_by(label: 'About')
    assert_equal 'about', about.slug
    # Contact Page
    contact = home.children.find_by(label: 'Contact')
    assert_equal 'contact', contact.slug
  end

end