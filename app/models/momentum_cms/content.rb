class MomentumCms::Content < ActiveRecord::Base

  # == MomentumCms ==========================================================

  self.table_name = 'momentum_cms_contents'

  # == Constants ============================================================
  # == Relationships ========================================================

  belongs_to :page

  has_many :blocks,
           dependent: :destroy

  accepts_nested_attributes_for :blocks

  # == Extensions ===========================================================
  has_paper_trail

  has_files

  translates :content,
             :label,
             fallbacks_for_empty_translations: true,
             versioning:                       :paper_trail

  # == Validations ==========================================================

  validates :label,
            presence: true

  # == Scopes ===============================================================
  # == Callbacks ============================================================
  # == Class Methods ========================================================
  # == Instance Methods =====================================================

end
