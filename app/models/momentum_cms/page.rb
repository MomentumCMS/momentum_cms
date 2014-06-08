class MomentumCms::Page < MomentumCms::Entry
  # == MomentumCms ==========================================================

  include MomentumCms::AncestryUtils

  # == Constants ============================================================
  # == Relationships ========================================================

  belongs_to :template

  # == Extensions ===========================================================
  # == Validations ==========================================================

  validates :slug,
            presence: true,
            uniqueness: {scope: [:site, :ancestry]}

  # == Scopes ===============================================================

  # == Callbacks ============================================================
  before_validation :assign_layout_from_template

  before_save :assign_paths

  after_update :regenerate_child_paths

  # == Class Methods ========================================================

  # == Instance Methods =====================================================

  protected
  def assign_layout_from_template
    self.layout = self.template
  end

  def assign_paths
    self.path = generate_path(self)
  end

  def regenerate_child_paths
    self.descendants.each do |descendant|
      descendant.path = generate_path(descendant)
      descendant.save
    end
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
