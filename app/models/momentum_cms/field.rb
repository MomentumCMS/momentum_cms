class MomentumCms::Field < ActiveRecord::Base
  # == MomentumCms ==========================================================

  self.table_name = 'momentum_cms_fields'

  # == Constants ============================================================
  # == Relationships ========================================================

  belongs_to :document

  belongs_to :field_template

  # == Extensions ===========================================================

  translates :value, fallbacks_for_empty_translations: true

  # == Validations ==========================================================
  # == Scopes ===============================================================
  # == Callbacks ============================================================
  # == Class Methods ========================================================
  # == Instance Methods =====================================================
end
