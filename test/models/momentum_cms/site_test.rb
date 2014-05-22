require_relative '../../test_helper'

class MomentumCms::SiteTest < ActiveSupport::TestCase
  def setup
    @site = momentum_cms_sites(:default)
  end

  def test_fixture_validity
    MomentumCms::Site.all.each do |site|
      assert site.valid?
    end
  end

  def test_create
    assert_difference 'MomentumCms::Site.count' do
      MomentumCms::Site.create(
        host: 'foo.host',
        label: 'Site Name',
        identifier: 'test'
      )
    end
    assert_no_difference 'MomentumCms::Site.count' do
      MomentumCms::Site.create(
        host: 'foo.host',
        label: 'Site Name',
        identifier: 'test'
      )
    end
  end

  def test_assign_identifier
    assert_difference 'MomentumCms::Site.count' do
      MomentumCms::Site.create(
        host: 'foo.host',
        label: 'Site Name'
      )
    end
  end

  def test_site_languages
    @site = MomentumCms::Site.create(
      host: 'foo.host',
      label: 'Site Name'
    )
    assert_equal @site.get_locales, ['en']
    assert_equal @site.get_locales(['en']), ['en']
    @site.available_locales = ['en', 'fr']
    @site.save!
    @site.reload
    assert_equal @site.get_locales, ['en', 'fr']
    assert_equal @site.get_locales(['en']), ['en', 'fr']
  end
end
