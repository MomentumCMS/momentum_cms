class MomentumCms::Layout < ActiveRecord::Base

  # == MomentumCms ==========================================================

  include MomentumCms::BelongsToSite

  include MomentumCms::ActAsPermanentRecord

  self.table_name = 'momentum_cms_layouts'

  # == Constants ============================================================
  # == Relationships ========================================================

  # has_many :pages,
  #          dependent: :destroy
  #
  # has_many :block_templates,
  #          dependent: :destroy

  # == Extensions ===========================================================

  translates :label, fallbacks_for_empty_translations: true

  # == Validations ==========================================================

  validates :label,
            presence: true

  validates :identifier,
            uniqueness: { scope: :site_id },
            presence: true

  # == Scopes ===============================================================
  # == Callbacks ============================================================
  # after_save :sync_block_identifiers,
  #            :update_descendants_block_templates

  # == Class Methods ========================================================

  # == Instance Methods =====================================================
  protected

  # def valid_liquid_value
  #   tbs = TemplateBlockService.new(self)
  #   unless tbs.valid_liquid?
  #     errors.add(:value, 'is not a valid liquid template')
  #   end
  #
  #   if !self.new_record? && !tbs.has_block?(MomentumCms::Tags::CmsYield) && self.has_children?
  #     errors.add(:value, 'is not a valid parent liquid template, you must include {% cms_yield %}')
  #   end
  # end
  #
  # def sync_block_identifiers
  #   if self.identifier_changed?
  #     to = self.identifier_change.last
  #   end
  # end
  #
  #
  # def update_descendants_block_templates
  #   TemplateBlockService.new(self).create_or_update_block_templates_for_self!
  # end
end
