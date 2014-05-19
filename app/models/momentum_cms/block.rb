class MomentumCms::Block < ActiveRecord::Base

  # == MomentumCms ==========================================================

  self.table_name = 'momentum_cms_blocks'

  # == Constants ============================================================
  # == Relationships ========================================================

  belongs_to :block_template

  belongs_to :content

  # == Extensions ===========================================================
  has_paper_trail

  translates :value, fallbacks_for_empty_translations: true, versioning: :paper_trail

  validates :block_template, :block_template_id,
            presence: true

  # == Validations ==========================================================
  # == Scopes ===============================================================
  # == Callbacks ============================================================
  # == Class Methods ========================================================
  # == Instance Methods =====================================================

end
