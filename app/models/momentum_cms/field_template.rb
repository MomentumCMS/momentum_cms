class MomentumCms::FieldTemplate < ActiveRecord::Base
  # == MomentumCms ==========================================================

  self.table_name = 'momentum_cms_field_templates'

  # == Constants ============================================================
  # == Relationships ========================================================

  belongs_to :document_template
  
  has_many :fields,
           dependent: :destroy

  # == Extensions ===========================================================
  
  has_paper_trail

  translates :label, fallbacks_for_empty_translations: true, versioning: :paper_trail

  # == Validations ==========================================================
  # == Scopes ===============================================================
  # == Callbacks ============================================================
  # == Class Methods ========================================================
  # == Instance Methods =====================================================
end
