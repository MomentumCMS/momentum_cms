class MomentumCms::Page < ActiveRecord::Base
  # == MomentumCms ==========================================================
  
  include MomentumCms::BelongsToSite

  self.table_name = 'momentum_cms_pages'

  # == Constants ============================================================
  # == Relationships ========================================================

  belongs_to :template

  has_many :blocks,
           inverse_of: :page,
           dependent: :destroy

  accepts_nested_attributes_for :blocks

  # == Extensions ===========================================================
  
  has_paper_trail

  has_ancestry
  
  translates :label, :slug, :path, fallbacks_for_empty_translations: true

  # == Validations ==========================================================

  validates :slug, uniqueness: { scope: [:site, :ancestry] }
  validates :slug, presence: true

  validates :identifier, uniqueness: { scope: :site }
  validates :identifier, presence: true

  validates :template, presence: true

  # == Scopes ===============================================================
  # == Callbacks ============================================================

  before_save :assign_paths
  after_update :regenerate_child_paths

  # == Class Methods ========================================================

  def self.ancestor_and_self!(page)
    if page && page.is_a?(MomentumCms::Page)
      [page.ancestors.to_a, page].flatten.compact
    else
      []
    end
  end

  # == Instance Methods =====================================================

  def assign_paths
    self.path = generate_path(self)
  end

  def regenerate_child_paths
    self.descendants.each do |descendant|
      descendant.path = generate_path(descendant)
      descendant.save
    end
  end

  def published_content
    self.contents.find_by(id: self.published_content_id)
  end

  protected

  def generate_path(page)
    translated_path = []
    translated_path = page.ancestors.collect(&:slug) if page && page.ancestors
    translated_path << page.slug
    path = "#{translated_path.join('/')}"
    path = "/#{path}" if !path.start_with?('/')
    path.gsub(/(\/{2,})/, '/')
  end
end
