class MomentumCms::DocumentTemplate < ActiveRecord::Base
  # == MomentumCms ==========================================================
  
  include MomentumCms::BelongsToSite
  
  self.table_name = 'momentum_cms_document_templates'

  # == Constants ============================================================
  # == Relationships ========================================================

  has_many :documents,
           dependent: :destroy
  
  has_many :field_templates,
           dependent: :destroy
  
  accepts_nested_attributes_for :field_templates

  # == Extensions ===========================================================
  
  has_ancestry

  has_paper_trail

  translates :label, fallbacks_for_empty_translations: true, versioning: :paper_trail

  # == Validations ==========================================================

  validates :identifier,
            presence: true

  validates :identifier,
            uniqueness: true
  
  # == Scopes ===============================================================
  # == Callbacks ============================================================
  # == Class Methods ========================================================
  # == Instance Methods =====================================================

end
