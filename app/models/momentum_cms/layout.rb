class MomentumCms::Layout < ActiveRecord::Base

  # == MomentumCms ==========================================================

  include MomentumCms::BelongsToSite

  include MomentumCms::ActAsPermanentRecord

  self.table_name = 'momentum_cms_layouts'

  # == Constants ============================================================
  # == Relationships ========================================================

  has_many :entries,
           dependent: :destroy

  has_many :field_templates,
           dependent: :destroy

  accepts_nested_attributes_for :field_templates

  # == Extensions ===========================================================

  translates :label,
             fallbacks_for_empty_translations: true

  # == Validations ==========================================================

  validates :label,
            presence: true

  validates :identifier,
            uniqueness: {scope: :site_id},
            presence: true

  # == Scopes ===============================================================
  # == Callbacks ============================================================
  # == Class Methods ========================================================
  # == Instance Methods =====================================================
  protected
end
