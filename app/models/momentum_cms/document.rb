class MomentumCms::Document < ActiveRecord::Base
  # == MomentumCms ==========================================================

  self.table_name = 'momentum_cms_documents'

  # == Constants ============================================================
  # == Relationships ========================================================

  belongs_to :document_template

  # == Extensions ===========================================================
  has_paper_trail

  translates :label, fallbacks_for_empty_translations: true, versioning: :paper_trail

  # == Validations ==========================================================
  # == Scopes ===============================================================
  # == Callbacks ============================================================
  # == Class Methods ========================================================
  # == Instance Methods =====================================================

end
