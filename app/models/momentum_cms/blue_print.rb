class MomentumCms::BluePrint < MomentumCms::Layout
  # == MomentumCms ==========================================================

  include MomentumCms::AncestryUtils

  # == Constants ============================================================
  # == Relationships ========================================================

  has_many :documents,
           dependent: :destroy

  has_many :field_templates,
           dependent: :destroy

  accepts_nested_attributes_for :field_templates

  # == Extensions ===========================================================

  has_ancestry

  # == Validations ==========================================================
  # == Scopes ===============================================================
  # == Callbacks ============================================================
  # == Class Methods ========================================================
  # == Instance Methods =====================================================
end
