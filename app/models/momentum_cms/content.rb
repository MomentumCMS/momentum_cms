class MomentumCms::Content < ActiveRecord::Base

  # == MomentumCms ==========================================================

  self.table_name = 'momentum_cms_contents'

  # == Constants ============================================================
  # == Relationships ========================================================

  belongs_to :page

  # == Extensions ===========================================================
  has_paper_trail

  translates :content, :label, fallbacks_for_empty_translations: true, versioning: :paper_trail

  # == Validations ==========================================================
  # == Scopes ===============================================================
  # == Callbacks ============================================================
  # == Class Methods ========================================================
  # == Instance Methods =====================================================

end
