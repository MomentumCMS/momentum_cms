class MomentumCms::FieldTemplate < ActiveRecord::Base
  # == MomentumCms ==========================================================

  self.table_name = 'momentum_cms_field_templates'

  # == Constants ============================================================
  # == Relationships ========================================================

  belongs_to :document_template

  has_many :fields,
           dependent: :destroy

  # == Extensions ===========================================================

  translates :label, fallbacks_for_empty_translations: true

  # == Validations ==========================================================
  # == Scopes ===============================================================
  # == Callbacks ============================================================
  # == Class Methods ========================================================
  # == Instance Methods =====================================================
  
  def to_identifier
    "#{self.document_template.identifier}::#{self.identifier}"
  end
end
