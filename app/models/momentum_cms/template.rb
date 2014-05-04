class MomentumCms::Template < ActiveRecord::Base

  # == MomentumCms ==========================================================

  self.table_name = 'momentum_cms_templates'

  # == Constants ============================================================
  # == Relationships ========================================================

  belongs_to :site

  has_many :pages

  # == Extensions ===========================================================
  # == Validations ==========================================================

  validate :valid_liquid_content

  def valid_liquid_content
    if self.content.present?
      begin
        Liquid::Template.parse(self.content)
      rescue
        errors.add(:content, "is not a valid liquid template")
      end
    end
  end


  # == Scopes ===============================================================
  # == Callbacks ============================================================
  # == Class Methods ========================================================
  # == Instance Methods =====================================================
end
