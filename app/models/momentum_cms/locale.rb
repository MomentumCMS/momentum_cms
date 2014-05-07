class MomentumCms::Locale < ActiveRecord::Base
  # == MomentumCms ==========================================================

  self.table_name = 'momentum_cms_locales'

  # == Constants ============================================================
  # == Relationships ========================================================
  # == Extensions ===========================================================
  # == Validations ==========================================================

  validates :label,
            :identifier,
            presence: true

  # == Scopes ===============================================================
  # == Callbacks ============================================================
  # == Class Methods ========================================================
  # == Instance Methods =====================================================
end
