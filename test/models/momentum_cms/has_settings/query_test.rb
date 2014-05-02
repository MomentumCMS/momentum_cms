require 'test_helper'

class MomentumCms::HasSettings::QueryTest < ActiveSupport::TestCase

  def setup
    MomentumCms::Site.class_eval do
      has_settings do |s|
        s.key :dashboard, defaults: { theme: 'blue', view: 'monthly', filter: true }
        s.key :calendar, defaults: { scope: 'company' }
      end
    end
  end

  def setup_query_count_test
    @site = MomentumCms::Site.new(label: 'Mr. Pink')
  end

  def test_new_record_should_be_saved_by_one_SQL_query
    setup_query_count_test
    asset_query_count_equal 1 do
      @site.save!
    end
  end

  def test_new_record_should_be_saved_with_settings_for_one_key_by_two_SQL_queries
    setup_query_count_test
    asset_query_count_equal 2 do
      @site.settings(:dashboard).foo = 42
      @site.settings(:dashboard).bar = 'string'
      @site.save!
    end
  end

  def test_new_record_should_be_saved_with_settings_for_two_keys_by_three_SQL_queries
    setup_query_count_test
    asset_query_count_equal 3 do
      @site.settings(:dashboard).foo = 42
      @site.settings(:dashboard).bar = 'string'
      @site.settings(:calendar).bar  = 'string'
      @site.save!
    end
  end

  def setup_existing_record_query_count_test
    @site = MomentumCms::Site.create!(label: 'Mr. Pink')
  end

  def test_existing_record_without_setting_should_be_saved_without_SQL_queries
    setup_existing_record_query_count_test
    asset_query_count_equal 0 do
      @site.save!
    end
  end

  def test_existing_record_without_setting_should_be_saved_with_settings_for_one_key_by_two_SQL_queries
    setup_existing_record_query_count_test
    asset_query_count_equal 2 do
      @site.settings(:dashboard).foo = 42
      @site.settings(:dashboard).bar = 'string'
      @site.save!
    end
  end

  def test_existing_record_without_setting_should_be_saved_with_settings_for_two_keys_by_three_SQL_queries
    setup_existing_record_query_count_test
    asset_query_count_equal 3 do
      @site.settings(:dashboard).foo = 42
      @site.settings(:dashboard).bar = 'string'
      @site.settings(:calendar).bar  = 'string'
      @site.save!
    end
  end

  def setup_existing_record_with_settings_query_count_test
    @site = MomentumCms::Site.create!(label: 'Mr. Pink') do |site|
      site.settings(:dashboard).theme = 'pink'
      site.settings(:calendar).scope  = 'all'
    end
  end

  def test_existing_record_with_settings_should_be_saved_without_SQL_queries
    setup_existing_record_with_settings_query_count_test
    asset_query_count_equal 0 do
      @site.save!
    end
  end

  def test_existing_record_with_settings_should_be_saved_with_settings_for_one_key_by_one_SQL_queries
    setup_existing_record_with_settings_query_count_test
    asset_query_count_equal 1 do
      @site.settings(:dashboard).foo = 42
      @site.settings(:dashboard).bar = 'string'
      @site.save!
    end
  end

  def test_existing_record_with_settings_should_be_saved_with_settings_for_two_keys_by_two_SQL_queries
    setup_existing_record_with_settings_query_count_test
    asset_query_count_equal 2 do
      @site.settings(:dashboard).foo = 42
      @site.settings(:dashboard).bar = 'string'
      @site.settings(:calendar).bar  = 'string'
      @site.save!
    end
  end

  def test_existing_record_with_settings_should_be_destroyed_by_two_SQL_queries
    setup_existing_record_with_settings_query_count_test
    asset_query_count_equal 2 do
      @site.destroy
    end
  end

  def test_existing_record_with_settings_should_update_settings_by_one_SQL_query
    setup_existing_record_with_settings_query_count_test
    asset_query_count_equal 1 do
      @site.settings(:dashboard).update_attributes! foo: 'bar'
    end
  end

  def test_existing_record_with_settings_should_not_touch_database_if_there_are_no_changes_made
    setup_existing_record_with_settings_query_count_test
    asset_query_count_equal 0 do
      @site.settings(:dashboard).update_attributes theme: 'pink'
      @site.settings(:calendar).update_attributes scope: 'all'
    end
  end

end