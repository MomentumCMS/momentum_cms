class MomentumCms::BlockTemplate < ActiveRecord::Base
  # == MomentumCms ==========================================================

  self.table_name = 'momentum_cms_block_templates'

  # == Constants ============================================================
  # == Relationships ========================================================

  belongs_to :template

  has_many :blocks,
           dependent: :destroy

  # == Extensions ===========================================================

  translates :label, fallbacks_for_empty_translations: true

  # == Validations ==========================================================
  # == Scopes ===============================================================
  # == Callbacks ============================================================
  # == Class Methods ========================================================
  # == Instance Methods =====================================================

  def to_identifier
    "#{self.template.identifier}::#{self.identifier}"
  end
end
