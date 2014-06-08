class MomentumCms::Template < MomentumCms::Layout
  # == MomentumCms ==========================================================

  include MomentumCms::AncestryUtils

  # == Constants ============================================================
  # == Relationships ========================================================

  has_many :pages,
           dependent: :destroy

  # == Extensions ===========================================================

  has_ancestry

  # == Validations ==========================================================

  validate :valid_liquid_value


  # == Scopes ===============================================================

  scope :has_yield,
        -> {
          where(has_yield: true)
        }

  # == Callbacks ============================================================

  before_validation :update_has_yield

  after_save :sync_field_identifiers,
             :update_descendants_field_templates

  # == Class Methods ========================================================

  # == Instance Methods =====================================================
  protected

  def valid_liquid_value
    tbs = TemplateBlockService.new(self)
    unless tbs.valid_liquid?
      errors.add(:value, 'is not a valid liquid template')
    end

    if !self.new_record? && !tbs.has_field?(MomentumCms::Tags::CmsYield) && self.has_children?
      errors.add(:value, 'is not a valid parent liquid template, you must include {% cms_yield %}')
    end
  end

  def sync_field_identifiers
    if self.identifier_changed?
      to = self.identifier_change.last
    end
  end

  def update_has_yield
    tbs = TemplateBlockService.new(self)
    self.has_yield = tbs.has_field?(MomentumCms::Tags::CmsYield)
    true
  end

  def update_descendants_field_templates
    TemplateBlockService.new(self).create_or_update_field_templates_for_self!
  end
end
