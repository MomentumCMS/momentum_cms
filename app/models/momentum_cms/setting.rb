class MomentumCms::Setting < ActiveRecord::Base
  # == MomentumCms ==========================================================

  self.table_name = 'momentum_cms_settings'

  # == Constants ============================================================

  REGEX_SETTER    = /\A([a-z]\w+)=\Z/i
  REGEX_GETTER    = /\A([a-z]\w+)\Z/i

  # == Relationships ========================================================

  belongs_to :target,
             polymorphic: true

  # == Extensions ===========================================================

  serialize :value, Hash

  # == Validations ==========================================================

  validates_presence_of :var, :target_type

  validate do
    errors.add(:value, "Invalid setting value") unless value.is_a? Hash

    unless _target_class.default_settings[var.to_sym]
      errors.add(:var, "#{var} is not defined!")
    end
  end

  # == Scopes ===============================================================
  # == Callbacks ============================================================
  # == Class Methods ========================================================
  # == Instance Methods =====================================================

  def respond_to?(method_name, include_priv=false)
    super || method_name.to_s =~ REGEX_SETTER
  end

  def method_missing(method_name, *args, &block)
    if block_given?
      super
    else
      if attribute_names.include?(method_name.to_s.sub('=', ''))
        super
      elsif method_name.to_s =~ REGEX_SETTER && args.size == 1
        _set_value($1, args.first)
      elsif method_name.to_s =~ REGEX_GETTER && args.size == 0
        _get_value($1)
      else
        super
      end
    end
  end

  private
  def _get_value(name)
    if value[name].nil?
      _target_class.default_settings[var.to_sym][name]
    else
      value[name]
    end
  end

  def _set_value(name, v)
    if value[name] != v
      value_will_change!

      if v.nil?
        value.delete(name)
      else
        value[name] = v
      end
    end
  end

  def _target_class
    target_type.constantize
  end

  # https://github.com/rails/rails/blob/4-0-stable/activerecord/lib/active_record/attribute_methods/dirty.rb#L73
  def update_record(*)
    super(keys_for_partial_write) if changed?
  end
end
