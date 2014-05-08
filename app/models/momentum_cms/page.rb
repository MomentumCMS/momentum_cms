class MomentumCms::Page < ActiveRecord::Base
  # == MomentumCms ==========================================================

  self.table_name = 'momentum_cms_pages'

  # == Constants ============================================================
  # == Relationships ========================================================

  belongs_to :site
  belongs_to :template
  has_many :contents,
           dependent: :destroy

  # == Extensions ===========================================================

  has_ancestry
  translates :slug, :path, fallbacks_for_empty_translations: true

  # == Validations ==========================================================
  # == Scopes ===============================================================
  # == Callbacks ============================================================

  before_save :assign_paths
  after_update :regenerate_child_paths

  # == Class Methods ========================================================
  # == Instance Methods =====================================================

  def assign_paths
    self.path = generate_path(self)
    self.internal_path = generate_internal_path(self)
  end

  def regenerate_child_paths
    self.descendants.each do |descendant|
      descendant.path = generate_path(descendant)
      descendant.internal_path = generate_internal_path(descendant)
      descendant.save
    end
  end

  protected

  def generate_internal_path(page)
    internal_path = []
    internal_path = page.ancestors.collect(&:label) if page && page.ancestors
    internal_path << page.label
    internal_path = internal_path.collect{|l| l.parameterize.downcase}
    internal_path = "#{internal_path.join('/')}"
    internal_path = "/#{internal_path}"
    internal_path.gsub(/(\/{2,})/, '/')
  end

  def generate_path(page)
    translated_path = []
    translated_path = page.ancestors.collect(&:slug) if page && page.ancestors
    translated_path << page.slug
    path = "#{translated_path.join('/')}"
    path = "/#{path}" if !path.start_with?('/')
    path.gsub(/(\/{2,})/, '/')
  end
end
