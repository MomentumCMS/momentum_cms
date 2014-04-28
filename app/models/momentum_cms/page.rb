class MomentumCms::Page < ActiveRecord::Base
  # == MomentumCms ==========================================================

  self.table_name = 'momentum_cms_pages'

  # == Constants ============================================================
  # == Relationships ========================================================

  belongs_to :site
  has_many :variations

  # == Extensions ===========================================================

  has_ancestry
  translates :slug, :path, fallbacks_for_empty_translations: true

  # == Validations ==========================================================
  # == Scopes ===============================================================
  # == Callbacks ============================================================

  before_save :assign_path
  after_update :regenerate_child_paths

  # == Class Methods ========================================================
  # == Instance Methods =====================================================

  def assign_path
    self.path = generate_path(self)
  end

  def regenerate_child_paths
    self.descendants.each do |descendant|
      descendant.path = generate_path(descendant)
      descendant.save
    end    
  end

  protected

  def generate_path(page)
    translated_path = []
    translated_path = page.ancestors.collect(&:slug) if page && page.ancestors
    translated_path << page.slug
    "/#{translated_path.join('/')}"
  end
end
