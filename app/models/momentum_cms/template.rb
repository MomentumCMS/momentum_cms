class MomentumCms::Template < ActiveRecord::Base

  # == MomentumCms ==========================================================
  include MomentumCms::BelongsToSite
  include MomentumCms::ActAsPermanentRecord

  self.table_name = 'momentum_cms_templates'

  # == Constants ============================================================
  # == Relationships ========================================================

  has_many :pages

  # == Extensions ===========================================================

  has_ancestry

  # == Validations ==========================================================

  validate :valid_liquid_content

  validates :label,
            presence: true

  validates :label,
            uniqueness: { scope: :site_id }

  # == Scopes ===============================================================

  # == Callbacks ============================================================

  after_save :update_descendants_block_templates

  def update_descendants_block_templates
    #TODO: Update myself's block templates because the parent could have changed.    
    descendants = MomentumCms::Template.descendants_of(self)
    #TODO: Resync template
  end

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

  def valid_liquid_content
    if self.content.present?
      Liquid::Template.parse(self.content)
    end
  rescue
    errors.add(:content, "is not a valid liquid template")
  end
end
