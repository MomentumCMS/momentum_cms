require 'test_helper'

class MomentumCms::SettingsTest < ActiveSupport::TestCase

  def setup
    @site = momentum_cms_sites(:default)
  end

  def test_should_define_single_key
    MomentumCms::HasSettings::Configuration.new(MomentumCms::Site, :dashboard)

    assert_equal MomentumCms::Site.default_settings, { :dashboard => {} }
  end

  def test_should_define_multiple_keys
    MomentumCms::HasSettings::Configuration.new(MomentumCms::Site, :dashboard, :calendar)

    assert_equal MomentumCms::Site.default_settings, { :dashboard => {}, :calendar => {} }
  end

  def test_should_define_using_block
    MomentumCms::HasSettings::Configuration.new(MomentumCms::Site) do |c|
      c.key :dashboard
      c.key :calendar
    end

    assert_equal MomentumCms::Site.default_settings, { :dashboard => {}, :calendar => {} }
  end

  def test_should_define_using_block_with_defaults
    MomentumCms::HasSettings::Configuration.new(MomentumCms::Site) do |c|
      c.key :dashboard, :defaults => { :theme => 'red' }
      c.key :calendar, :defaults => { :scope => 'all' }
    end

    assert_equal MomentumCms::Site.default_settings, { :dashboard => { 'theme' => 'red' }, :calendar => { 'scope' => 'all' } }
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

  def test_should_fail_with_keys_not_being_symbols
    assert_raises(ArgumentError) do
      MomentumCms::HasSettings::Configuration.new(MomentumCms::Site) do |c|
        c.key 42, "string"
      end
    end
  end

  def test_should_fail_with_unknown_option
    assert_raises(ArgumentError) do
      MomentumCms::HasSettings::Configuration.new(MomentumCms::Site) do |c|
        c.key :dashboard, :foo => {}
      end
    end
  end

  def setup_serializer_test
    MomentumCms::Site.class_eval do
      has_settings do |s|
        s.key :dashboard, :defaults => { :theme => 'blue', :view => 'monthly', :filter => true }
        s.key :calendar, :defaults => { :scope => 'company' }
      end
    end

    @site = MomentumCms::Site.create! :label => 'Mr. White' do |site|
      site.settings(:dashboard).theme = 'white'
      site.settings(:calendar).scope  = 'all'
    end
  end

  def test_created_settings_should_be_serialized

    setup_serializer_test

    dashboard_settings = @site.setting_objects.where(:var => 'dashboard').first
    calendar_settings  = @site.setting_objects.where(:var => 'calendar').first

    assert_equal dashboard_settings.var, 'dashboard'
    assert_equal dashboard_settings.value, { 'theme' => 'white' }

    assert_equal calendar_settings.var, 'calendar'
    assert_equal calendar_settings.value, { 'scope' => 'all' }
  end

  def test_updated_settings_should_be_serialized

    setup_serializer_test

    @site.settings(:dashboard).update_attributes! :smart => true

    dashboard_settings = @site.setting_objects.where(:var => 'dashboard').first
    calendar_settings  = @site.setting_objects.where(:var => 'calendar').first

    assert_equal dashboard_settings.var, 'dashboard'
    assert_equal dashboard_settings.value, { 'theme' => 'white', 'smart' => true }

    assert_equal calendar_settings.var, 'calendar'
    assert_equal calendar_settings.value, { 'scope' => 'all' }
  end

  def setup_scopes_test
    MomentumCms::Site.class_eval do
      has_settings do |s|
        s.key :dashboard, :defaults => { :theme => 'blue', :view => 'monthly', :filter => true }
        s.key :calendar, :defaults => { :scope => 'company' }
      end
    end
    
    MomentumCms::Site.delete_all
    
    @site1 = MomentumCms::Site.create! :label => 'Mr. White' do |site|
      site.settings(:dashboard).theme = 'white'
    end
    @site2 = MomentumCms::Site.create! :label => 'Mr. Blue'
  end

  def test_should_find_objects_with_existing_settings
    setup_scopes_test
    assert_equal MomentumCms::Site.with_settings, [@site1]
  end

  def test_should_find_objects_with_settings_for_key
    setup_scopes_test
    assert_equal MomentumCms::Site.with_settings_for(:dashboard), [@site1]
    assert_equal MomentumCms::Site.with_settings_for(:foo), []
  end

  def test_should_records_without_settings
    setup_scopes_test
    assert_equal MomentumCms::Site.without_settings, [@site2]
  end

  def test_should_records_without_settings_for_key
    setup_scopes_test
    assert_equal MomentumCms::Site.without_settings_for(:foo).to_a, [@site1, @site2]
    assert_equal MomentumCms::Site.without_settings_for(:dashboard).to_a, [@site2]
  end

  def test_should_require_symbol_as_key
    setup_scopes_test
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