class MomentumCms::BluePrint < ActiveRecord::Base
  # == MomentumCms ==========================================================

  include MomentumCms::BelongsToSite

  include MomentumCms::AncestryUtils

  self.table_name = 'momentum_cms_blue_prints'

  # == Constants ============================================================
  # == Relationships ========================================================

  has_many :documents,
           dependent: :destroy

  has_many :field_templates,
           dependent: :destroy

  accepts_nested_attributes_for :field_templates

  # == Extensions ===========================================================

  has_ancestry

  translates :label, fallbacks_for_empty_translations: true

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
