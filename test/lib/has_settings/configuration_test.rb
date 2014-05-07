require 'test_helper'

class MomentumCms::HasSettings::ConfigurationTest < ActiveSupport::TestCase

  def test_should_define_single_key
    MomentumCms::HasSettings::Configuration.new(MomentumCms::Site, :dashboard)

    assert_equal MomentumCms::Site.default_settings, { dashboard: {} }
  end

  def test_should_define_multiple_keys
    MomentumCms::HasSettings::Configuration.new(MomentumCms::Site, :dashboard, :calendar)

    assert_equal MomentumCms::Site.default_settings, { dashboard: {}, calendar: {} }
  end

  def test_should_define_using_block
    MomentumCms::HasSettings::Configuration.new(MomentumCms::Site) do |c|
      c.key :dashboard
      c.key :calendar
    end

    assert_equal MomentumCms::Site.default_settings, { dashboard: {}, calendar: {} }
  end

  def test_should_define_using_block_with_defaults
    MomentumCms::HasSettings::Configuration.new(MomentumCms::Site) do |c|
      c.key :dashboard, defaults: { theme: 'red' }
      c.key :calendar, defaults: { scope: 'all' }
    end

    assert_equal MomentumCms::Site.default_settings, { dashboard: { 'theme' => 'red' }, calendar: { 'scope' => 'all' } }
  end

  def test_should_fail_without_args
    assert_raises(ArgumentError) do
      MomentumCms::HasSettings::Configuration.new
    end
  end

  def test_should_fail_without_keys
    assert_raises(ArgumentError) do
      MomentumCms::HasSettings::Configuration.new(MomentumCms::Site)
    end
  end

  def test_should_fail_without_keys_in_block
    assert_raises(ArgumentError) do
      MomentumCms::HasSettings::Configuration.new(MomentumCms::Site) do |c|
      end
    end
  end

  def test_should_fail_with_keys_not_being_symbols
    assert_raises(ArgumentError) do
      MomentumCms::HasSettings::Configuration.new(MomentumCms::Site, 42, "string")
    end
  end

  def test_should_fail_with_keys_not_being_symbols_in_block
    assert_raises(ArgumentError) do
      MomentumCms::HasSettings::Configuration.new(MomentumCms::Site) do |c|
        c.key 42, "string"
      end
    end
  end

  def test_should_fail_with_unknown_option
    assert_raises(ArgumentError) do
      MomentumCms::HasSettings::Configuration.new(MomentumCms::Site) do |c|
        c.key :dashboard, foo: {}
      end
    end
  end
end