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
      begin
        Liquid::Template.parse(self.content)
      rescue
        errors.add(:content, "is not a valid liquid template")
      end
    end
  end
end
