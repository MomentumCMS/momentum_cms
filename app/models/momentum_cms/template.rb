class MomentumCms::Template < ActiveRecord::Base

  # == MomentumCms ==========================================================
  include MomentumCms::BelongsToSite
  include MomentumCms::ActAsPermanentRecord

  self.table_name = 'momentum_cms_templates'

  # == Constants ============================================================
  # == Relationships ========================================================

  has_many :pages,
           dependent: :destroy

  has_many :block_templates,
           dependent: :destroy

  # == Extensions ===========================================================

  has_ancestry

  # == Validations ==========================================================

  validate :valid_liquid_value

  validates :label,
            presence: true

  validates :label,
            uniqueness: { scope: :site_id }

  # == Scopes ===============================================================

  scope :has_yield, -> { where(has_yield: true) }

  # == Callbacks ============================================================

  before_validation :update_has_yield

  after_save :update_descendants_block_templates

  # == Class Methods ========================================================

  def self.ancestor_and_self!(template)
    if template && template.is_a?(MomentumCms::Template)
      [template.ancestors.to_a, template].flatten.compact
    else
      []
    end
  end

  # == Instance Methods =====================================================
  protected

  def valid_liquid_value
    tbs = TemplateBlockService.new(self)
    unless tbs.valid_liquid?
      errors.add(:value, "is not a valid liquid template")
    end

    if !self.new_record? && !tbs.has_block?(MomentumCms::Tags::CmsYield) && self.has_children?
      errors.add(:value, "is not a valid parent liquid template, you must include {% cms_yield %}")
    end
  end

  def update_has_yield
    tbs = TemplateBlockService.new(self)
    self.has_yield = tbs.has_block?(MomentumCms::Tags::CmsYield)
    true
  end

  def update_descendants_block_templates
    TemplateBlockTemplateService.new(self).create_or_update_block_templates_for_self!
    # #TODO: Update myself's block templates because the parent could have changed.
    # descendants = MomentumCms::Template.descendants_of(self)
    # #TODO: Resync template
  end
end
