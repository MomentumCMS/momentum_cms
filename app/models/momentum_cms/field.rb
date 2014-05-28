class MomentumCms::Field < ActiveRecord::Base
  # == MomentumCms ==========================================================

  self.table_name = 'momentum_cms_fields'

  # == Constants ============================================================
  # == Relationships ========================================================

  belongs_to :document

  belongs_to :field_template

  # == Extensions ===========================================================

  has_paper_trail

  translates :value, fallbacks_for_empty_translations: true, versioning: :paper_trail

  # == Validations ==========================================================
  # == Scopes ===============================================================
  # == Callbacks ============================================================
  # == Class Methods ========================================================
  # == Instance Methods =====================================================
end
