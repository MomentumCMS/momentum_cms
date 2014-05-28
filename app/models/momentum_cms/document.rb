class MomentumCms::Document < ActiveRecord::Base
  # == MomentumCms ==========================================================

  include MomentumCms::BelongsToSite

  self.table_name = 'momentum_cms_documents'

  # == Constants ============================================================
  # == Relationships ========================================================

  belongs_to :document_template

  has_many :fields,
           inverse_of: :document,
           dependent: :destroy

  accepts_nested_attributes_for :fields

  # == Extensions ===========================================================
  
  has_paper_trail

  translates :label, fallbacks_for_empty_translations: true, versioning: :paper_trail

  # == Validations ==========================================================

  validates :document_template,
            presence: true

  # == Scopes ===============================================================
  # == Callbacks ============================================================
  # == Class Methods ========================================================
  # == Instance Methods =====================================================

end
