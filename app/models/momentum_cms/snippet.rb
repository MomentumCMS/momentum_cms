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

  validate :validate_value_does_not_nest

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

  def validate_value_does_not_nest
    template = Liquid::Template.parse(self.value)
    template.root.nodelist.each do |node|
      if node.is_a?(MomentumCms::Tags::CmsSnippet)
        self.errors.add(:value, 'can not contain another {% cms_snippet %} tag.')
      end
    end
  rescue
    self.errors.add(:value, 'is not a valid liquid markup')
  end
end
