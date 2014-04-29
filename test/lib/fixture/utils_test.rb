require_relative '../../test_helper'

class FixtureUtilsTest < ActiveSupport::TestCase

  def setup
    @write_path = File.join(Rails.root, 'sites', 'example-a', 'write.json')
    File.delete(@write_path) if File.exist?(@write_path)
  end

  def teardown
    File.delete(@write_path) if File.exist?(@write_path)
  end

  def test_read_json
    path = File.join(Rails.root, 'sites', 'example-a', 'attributes.json')
    json = MomentumCms::Fixture::Utils.read_json(path)
    assert_equal 'Example A',     json['label']
    assert_equal 'example-a.dev', json['host']
  end

  def test_write_json
    data = {server: 'Ruby on Rails', client: 'Ember.js'}
    MomentumCms::Fixture::Utils.write_json(@write_path, data)
    assert_equal 'Ruby on Rails', MomentumCms::Fixture::Utils.read_json(@write_path)['server']
    assert_equal 'Ember.js', MomentumCms::Fixture::Utils.read_json(@write_path)['client']
  end

end