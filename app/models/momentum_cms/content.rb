class MomentumCms::Content < ActiveRecord::Base

  # == MomentumCms ==========================================================

  self.table_name = 'momentum_cms_contents'

  # == Constants ============================================================
  # == Relationships ========================================================

  belongs_to :page
  belongs_to :template

  has_many :blocks,
           dependent: :destroy

  accepts_nested_attributes_for :blocks

  # == Extensions ===========================================================
  has_paper_trail

  has_files

  translates :label,
             fallbacks_for_empty_translations: true,
             versioning: :paper_trail

  # == Validations ==========================================================

  validates :default, uniqueness: { scope: :page_id }

  # == Scopes ===============================================================

  scope :default, -> { where(default: true) }

  # == Callbacks ============================================================
  # == Class Methods ========================================================
  # == Instance Methods =====================================================

  def published?
    self.page && !self.new_record? && self.page.published_content_id == self.id
  end

  def default?
    self.default
  end

end
