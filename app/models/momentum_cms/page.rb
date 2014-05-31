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

  has_many :revisions,
           as: :revisable,
           dependent: :destroy

  attr_accessor :revision_data

  accepts_nested_attributes_for :revisions
  
  # == Extensions ===========================================================

  has_ancestry

  translates :label, :slug, :path, fallbacks_for_empty_translations: true

  # == Validations ==========================================================

  validates :slug, uniqueness: { scope: [:site, :ancestry] } , presence: true

  validates :identifier, uniqueness: { scope: :site } , presence: true

  validates :template, presence: true

  # == Scopes ===============================================================

  scope :published,
        -> {
          where(published: true)
        }

  # == Callbacks ============================================================
  
  before_create :create_revision
  
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

  def unpublish!
    self.update_attributes(published: false)
    MomentumCms::Revision.unpublish_for!(self)
  end

  def publish!
    self.update_attributes(published: true)
    revision = {}
    revision[:page] = self.attributes
    revision[:page_translation] = self.translations.to_a.collect(&:attributes)
    revision[:blocks] = []
    revision[:blocks_translations] = []
    self.blocks.draft_blocks.each do |block|
      revision[:blocks] << block.attributes
      revision[:blocks_translations] << block.translations.to_a.collect(&:attributes)
    end
    revision[:blocks].flatten!
    revision[:blocks_translations].flatten!
    MomentumCms::Revision.publish_and_create_draft_for!(self, revision)

    self.blocks.draft_blocks.each do |block|
      published_block = block.revision_block
      MomentumCms::Fixture::Utils.each_locale_for_site(self.site) do |locale|
        published_block.value = block.value
        published_block.save!
      end
    end
  end

  def create_revision
    MomentumCms::Revision.build_draft_for!(self)
  end

  def published?
    !!self.published
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
