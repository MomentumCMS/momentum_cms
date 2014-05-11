class MomentumCms::Snippet < ActiveRecord::Base
  # == MomentumCms ==========================================================
  include MomentumCms::BelongsToSite

  self.table_name = 'momentum_cms_snippets'

  # == Constants ============================================================
  # == Relationships ========================================================

  # == Extensions ===========================================================

  translates :value, fallbacks_for_empty_translations: true

  # == Validations ==========================================================

  validates :label, :slug,
            presence: true

  validates :slug,
            uniqueness: true

  # == Scopes ===============================================================
  # == Callbacks ============================================================

  before_validation :assign_slug

  # == Class Methods ========================================================
  # == Instance Methods =====================================================

  protected
  def assign_slug
    if self.slug.blank?
      self.slug = self.label.to_slug
    end
  end
end
