require 'test_helper'

class MomentumCms::SettingsTest < ActiveSupport::TestCase
  def setup
    MomentumCms::Site.class_eval do
      has_settings do |s|
        s.key :dashboard, defaults: { theme: 'blue', view: 'monthly', filter: true }
        s.key :calendar, defaults: { scope: 'company' }
      end
    end

    @setting = MomentumCms::Site.create! label: 'cms site', host: 'test.dev', identifier: 'test2'

    @new_setting_object = @setting.dup
    @new_setting_object.identifier = 'test3'
    @new_setting_object.save!
    @new_setting_object = @new_setting_object.setting_objects.build({ var: 'dashboard' })

    @saved_setting_object = @setting.dup
    @saved_setting_object.identifier = 'test4'
    @saved_setting_object.save!
    @saved_setting_object = @saved_setting_object.setting_objects.create!({ var: 'dashboard', value: { 'theme' => 'pink', 'filter' => false } })
  end

  def test_serialization_should_have_a_hash_default
    assert_equal ::MomentumCms::Setting.new.value, {}
  end

  def test_on_unsaved_settings_should_respond_to_setters
    assert @new_setting_object.respond_to?(:foo=)
    assert @new_setting_object.respond_to?(:bar=)
  end

  def test_on_unsaved_settings_should_not_respond_to_getters
    assert_raises(NoMethodError) do
      @new_setting_object.foo!
    end
    assert_raises(NoMethodError) do
      @new_setting_object.foo?
    end
  end

  def test_on_unsaved_settings_should_not_respond_if_a_block_is_given
    assert_raises(NoMethodError) do
      @new_setting_object.foo do
      end
    end
  end

  def test_on_unsaved_settings_should_not_respond_if_params_are_given
    assert_raises(NoMethodError) do
      @new_setting_object.foo(42)
    end
    assert_raises(NoMethodError) do
      @new_setting_object.foo(42, 43)
    end
  end

  def test_on_unsaved_settings_should_return_nil_for_unknown_attribute
    assert_nil @new_setting_object.foo
    assert_nil @new_setting_object.bar
  end

  def test_on_unsaved_settings_should_return_defaults
    assert_equal @new_setting_object.theme, 'blue'
    assert_equal @new_setting_object.view, 'monthly'
    assert_equal @new_setting_object.filter, true
  end

  def test_on_unsaved_settings_should_store_different_objects_to_value_hash
    @new_setting_object.integer = 42
    @new_setting_object.float   = 1.234
    @new_setting_object.string  = 'Hello, World!'
    @new_setting_object.array   = [1, 2, 3]
    @new_setting_object.symbol  = :foo

    assert_equal @new_setting_object.value, { 'integer' => 42,
                                              'float'   => 1.234,
                                              'string'  => 'Hello, World!',
                                              'array'   => [1, 2, 3],
                                              'symbol'  => :foo }
  end

  def test_on_unsaved_settings_should_set_and_return_attributes
    @new_setting_object.theme = 'pink'
    @new_setting_object.foo   = 42
    @new_setting_object.bar   = 'hello'

    assert_equal @new_setting_object.theme, 'pink'
    assert_equal @new_setting_object.foo, 42
    assert_equal @new_setting_object.bar, 'hello'
  end

  def test_on_unsaved_settings_should_set_dirty_trackers_on_change
    @new_setting_object.theme = 'pink'

    assert @new_setting_object.value_changed?
    assert @new_setting_object.changed?
  end

  def test_on_saved_settings_should_not_set_dirty_trackers_on_setting_same_value
    @saved_setting_object.theme = 'pink'
    refute @saved_setting_object.value_changed?
    refute @saved_setting_object.changed?
  end

  def test_on_saved_settings_should_delete_key_on_assigning_nil
    @saved_setting_object.theme = nil
    assert_equal @saved_setting_object.value, { 'filter' => false }
  end

  def test_update_attributes_should_save
    @new_setting_object.update_attributes!(:foo => 42, :bar => 'string')
    @new_setting_object.reload

    assert_equal @new_setting_object.foo, 42
    assert_equal @new_setting_object.bar, 'string'

    refute @new_setting_object.new_record?

    refute_equal @new_setting_object.id, 0
  end

  def test_update_attributes_should_not_save_blank_hash
    assert @new_setting_object.update_attributes({})
  end

  def test_save_should_save
    @new_setting_object.foo = 42
    @new_setting_object.bar = 'string'
    assert @new_setting_object.save
    @new_setting_object.reload

    assert_equal @new_setting_object.foo, 42
    assert_equal @new_setting_object.bar, 'string'
    refute @new_setting_object.new_record?
    refute_equal @new_setting_object.id, 0
  end

  def test_validation_should_not_validate_for_unknown_var
    @new_setting_object.var = 'unknown-var'

    refute @new_setting_object.valid?

    assert_equal @new_setting_object.errors[:var], ['unknown-var is not defined!']
  end
end
