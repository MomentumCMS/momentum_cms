class MomentumCms::Link < ActiveRecord::Base
  # == MomentumCms ==========================================================

  include MomentumCms::BelongsToSite

  self.table_name = 'momentum_cms_links'

  # == Constants ============================================================
  # == Relationships ========================================================
  # == Extensions ===========================================================

  translates :label, :description,
             fallbacks_for_empty_translations: true

  # == Validations ==========================================================

  validates :identifier,
            presence: true,
            uniqueness: {scope: :site_id}

  # == Scopes ===============================================================
  # == Callbacks ============================================================
  # == Class Methods ========================================================
  # == Instance Methods =====================================================
  protected
end
