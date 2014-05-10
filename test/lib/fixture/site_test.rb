require_relative '../../test_helper'

class FixtureSiteTest < ActiveSupport::TestCase

  def setup
    @export_path = File.join(Rails.root, 'sites', 'example-c')
    FileUtils.rm_rf(@export_path) if File.exist?(@export_path)
  end

  def teardown
    FileUtils.rm_rf(@export_path) if File.exist?(@export_path)
  end

  def test_basic_import
    assert_difference 'MomentumCms::Site.count' do
      MomentumCms::Fixture::Site::Importer.new('example-a').import!
    end
  end

  def test_duplicate_import
    assert_difference 'MomentumCms::Site.count' do
      MomentumCms::Fixture::Site::Importer.new('example-a').import!
      MomentumCms::Fixture::Site::Importer.new('example-a').import!
    end
  end

  def test_basic_export
    site = momentum_cms_sites(:default)
    MomentumCms::Fixture::Site::Exporter.new('example-c', site).export!
    assert File.exist?(@export_path)
    assert File.exist?(File.join(@export_path, 'attributes.json'))
    attributes = MomentumCms::Fixture::Utils.read_json(File.join(@export_path, 'attributes.json'))
    assert_equal site.label, attributes['label']
    assert_equal site.host, attributes['host']
  end

  def test_duplicate_export
    # Should not raise any errors
    site = momentum_cms_sites(:default)
    MomentumCms::Fixture::Site::Exporter.new('example-c', site).export!
    MomentumCms::Fixture::Site::Exporter.new('example-c', site).export!
  end

end
