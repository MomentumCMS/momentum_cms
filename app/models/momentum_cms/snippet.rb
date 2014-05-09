class MomentumCms::Snippet < ActiveRecord::Base
  # == MomentumCms ==========================================================

  self.table_name = 'momentum_cms_snippets'

  # == Constants ============================================================
  # == Relationships ========================================================

  belongs_to :site

  # == Extensions ===========================================================

  translates :value, fallbacks_for_empty_translations: true


  # == Validations ==========================================================

  validates :label,
            presence: true

  validates :label,
            uniqueness: true

  # == Scopes ===============================================================
  # == Callbacks ============================================================
  # == Class Methods ========================================================
  # == Instance Methods =====================================================
end
