require 'test_helper'

class MomentumCms::HasSettings::SeralizeTest < ActiveSupport::TestCase
  def setup
    MomentumCms::Site.class_eval do
      has_settings do |s|
        s.key :dashboard, defaults: { theme: 'blue', view: 'monthly', filter: true }
        s.key :calendar, defaults: { scope: 'company' }
      end
    end

    @site = MomentumCms::Site.create! label: 'Mr. White' do |site|
      site.settings(:dashboard).theme = 'white'
      site.settings(:calendar).scope  = 'all'
    end
  end

  def test_created_settings_should_be_serialized
    dashboard_settings = @site.setting_objects.where(var: 'dashboard').first
    calendar_settings  = @site.setting_objects.where(var: 'calendar').first

    assert_equal dashboard_settings.var, 'dashboard'
    assert_equal dashboard_settings.value, { 'theme' => 'white' }

    assert_equal calendar_settings.var, 'calendar'
    assert_equal calendar_settings.value, { 'scope' => 'all' }
  end

  def test_updated_settings_should_be_serialized
    @site.settings(:dashboard).update_attributes! smart: true

    dashboard_settings = @site.setting_objects.where(var: 'dashboard').first
    calendar_settings  = @site.setting_objects.where(var: 'calendar').first

    assert_equal dashboard_settings.var, 'dashboard'
    assert_equal dashboard_settings.value, { 'theme' => 'white', 'smart' => true }

    assert_equal calendar_settings.var, 'calendar'
    assert_equal calendar_settings.value, { 'scope' => 'all' }
  end

end