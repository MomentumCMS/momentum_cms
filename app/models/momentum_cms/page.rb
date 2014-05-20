class MomentumCms::Page < ActiveRecord::Base
  # == MomentumCms ==========================================================
  include MomentumCms::BelongsToSite

  self.table_name = 'momentum_cms_pages'

  # == Constants ============================================================
  # == Relationships ========================================================

  belongs_to :template
  has_many :contents,
           dependent: :destroy
  accepts_nested_attributes_for :contents

  # == Extensions ===========================================================

  has_ancestry
  translates :slug, :path, fallbacks_for_empty_translations: true

  # == Validations ==========================================================

  validates :slug, uniqueness: { scope: [:site, :ancestry] }

  # == Scopes ===============================================================
  # == Callbacks ============================================================

  before_save :assign_paths
  after_create :set_published_content_id
  after_update :regenerate_child_paths

  # == Class Methods ========================================================
  # == Instance Methods =====================================================

  def build_default_content
    if self.new_record? && self.contents.find_by(default: true).nil? && self.contents.length == 0
      content = self.contents.build(default: true, label: 'Default')
    else
      content = self.contents.find_by(default: true)
    end
    content
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

  def published_content
    self.contents.find_by(id: self.published_content_id)
  end

  protected

  def set_published_content_id
    self.update_column(:published_content_id, self.contents.default.first.id) unless self.contents.default.blank?
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
