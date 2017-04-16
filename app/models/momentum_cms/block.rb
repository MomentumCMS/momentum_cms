class MomentumCms::Block < ActiveRecord::Base
  # == MomentumCms ==========================================================

  self.table_name = 'momentum_cms_blocks'

  # == Constants ============================================================
  # == Relationships ========================================================

  belongs_to :block_template

  belongs_to :page

  belongs_to :revision_block,
             class_name: 'MomentumCms::Block',
             primary_key: :id,
             foreign_key: :revision_block_id

  # == Extensions ===========================================================

  translates :value, fallbacks_for_empty_translations: true

  validates :block_template,
            presence: true

  validates :page,
            presence: true

  # == Validations ==========================================================
  # == Scopes ===============================================================

  scope :draft_blocks,
        -> {
          where(block_type: 'draft')
        }

  scope :published_blocks,
        -> {
          where(block_type: 'published')
        }

  # == Callbacks ============================================================

  before_validation :assign_block_type

  after_create :create_revision_block
  after_destroy :destroy_revision_block

  # == Class Methods ========================================================

  # == Instance Methods =====================================================

  def draft?
    self.block_type == 'draft'
  end

  def published?
    self.block_type == 'published'
  end

  protected
  def create_revision_block
    if self.draft?
      block = self.dup
      block.block_type = 'published'
      block.revision_block_id = self.id
      block.save
      self.revision_block_id = block.id
      self.save
    end
  end

  def destroy_revision_block
    if self.draft?
      self.revision_block.try(:destroy)
    end
  end

  def assign_block_type
    if self.block_type.blank?
      self.block_type = 'draft'
    end
  end
end
