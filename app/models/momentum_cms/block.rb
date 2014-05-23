class MomentumCms::Block < ActiveRecord::Base

  # == MomentumCms ==========================================================

  self.table_name = 'momentum_cms_blocks'

  # == Constants ============================================================
  # == Relationships ========================================================

  belongs_to :block_template

  belongs_to :page

  # == Extensions ===========================================================
  has_paper_trail

  translates :value, fallbacks_for_empty_translations: true, versioning: :paper_trail

  validates :block_template,
            presence: true

  validates :page,
            presence: true

  # == Validations ==========================================================
  # == Scopes ===============================================================
  # == Callbacks ============================================================
  # == Class Methods ========================================================
  # == Instance Methods =====================================================

end
