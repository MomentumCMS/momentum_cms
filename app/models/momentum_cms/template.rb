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


  validates :identifier,
            presence: true

  validates :identifier,
            uniqueness: { scope: :site_id }


  # == Scopes ===============================================================

  scope :has_yield, -> { where(has_yield: true) }

  # == Callbacks ============================================================

  before_validation :update_has_yield

  after_save :sync_block_identifiers,
             :update_descendants_block_templates

  # == Class Methods ========================================================

  def self.ancestry_select(require_root = true, set = nil, path = nil)
    momentum_cms_templates_tree = if set.nil?
                                    MomentumCms::Template.all
                                  else
                                    set
                                  end
    select = []
    momentum_cms_templates_tree.each do |momentum_cms_template|
      next if require_root && !momentum_cms_template.is_root?
      select << { id: momentum_cms_template.id, label: "#{path} #{momentum_cms_template.label}" }
      select << MomentumCms::Template.ancestry_select(false, momentum_cms_template.children, "#{path}-")
    end
    select.flatten!
    select.collect! { |x| [x[:label], x[:id]] } if require_root
    select
  end

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
      errors.add(:value, 'is not a valid liquid template')
    end

    if !self.new_record? && !tbs.has_block?(MomentumCms::Tags::CmsYield) && self.has_children?
      errors.add(:value, 'is not a valid parent liquid template, you must include {% cms_yield %}')
    end
  end

  def sync_block_identifiers
    if self.identifier_changed?
      to = self.identifier_change.last


    end
  end

  def update_has_yield
    tbs = TemplateBlockService.new(self)
    self.has_yield = tbs.has_block?(MomentumCms::Tags::CmsYield)
    true
  end

  def update_descendants_block_templates
    TemplateBlockService.new(self).create_or_update_block_templates_for_self!
  end
end
