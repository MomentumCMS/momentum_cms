require 'test_helper'

class MomentumCms::HasSettings::ScopeTest < ActiveSupport::TestCase
  def setup
    MomentumCms::Site.class_eval do
      has_settings do |s|
        s.key :dashboard, defaults: { theme: 'blue', view: 'monthly', filter: true }
        s.key :calendar, defaults: { scope: 'company' }
      end
    end

    MomentumCms::Site.delete_all

    @site1 = MomentumCms::Site.create! label: 'Mr. White' do |site|
      site.settings(:dashboard).theme = 'white'
    end
    @site2 = MomentumCms::Site.create! label: 'Mr. Blue'
  end

  def test_should_find_objects_with_existing_settings
    assert_equal MomentumCms::Site.with_settings, [@site1]
  end

  def test_should_find_objects_with_settings_for_key
    assert_equal MomentumCms::Site.with_settings_for(:dashboard), [@site1]
    assert_equal MomentumCms::Site.with_settings_for(:foo), []
  end

  def test_should_records_without_settings
    assert_equal MomentumCms::Site.without_settings, [@site2]
  end

  def test_should_records_without_settings_for_key
    assert_equal MomentumCms::Site.without_settings_for(:foo).to_a, [@site1, @site2]
    assert_equal MomentumCms::Site.without_settings_for(:dashboard).to_a, [@site2]
  end

  def test_should_require_symbol_as_key
    [nil, "string", 42].each do |invalid_key|
      assert_raises(ArgumentError) do
        MomentumCms::Site.without_settings_for(invalid_key)
      end
      assert_raises(ArgumentError) do
        MomentumCms::Site.with_settings_for(invalid_key)
      end
    end
  end
end