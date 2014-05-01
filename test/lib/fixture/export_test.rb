require_relative '../../test_helper'

class FixtureExportTest < ActiveSupport::TestCase

  def setup
    @export_path = File.join(Rails.root, 'sites', 'example-c')
    FileUtils.rm_rf(@export_path) if File.exist?(@export_path)
  end

  def teardown
    FileUtils.rm_rf(@export_path) if File.exist?(@export_path)
  end

 def test_basic_site_export
    site = momentum_cms_sites(:default)
    MomentumCms::Fixture::Export.site(@export_path, site)
    json_data = MomentumCms::Fixture::Utils.read_json(File.join(@export_path, 'attributes.json'))
    assert_equal site.label, json_data['label']
    assert_equal site.host, json_data['host']
  end

end