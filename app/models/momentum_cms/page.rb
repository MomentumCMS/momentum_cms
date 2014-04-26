class MomentumCms::Page < ActiveRecord::Base
  # == MomentumCms ==========================================================

  self.table_name = 'momentum_cms_pages'

  # == Constants ============================================================
  # == Relationships ========================================================

  belongs_to :site
  has_many :variations

  # == Extensions ===========================================================

  acts_as_nested_set
  translates :slug, :path

  # == Validations ==========================================================
  # == Scopes ===============================================================
  # == Callbacks ============================================================

  before_save :assign_path

  # == Class Methods ========================================================
  # == Instance Methods =====================================================

  # TODO:
  # Loop through all available locales for this page and build the expected
  # path. All pages have a slug in (at least) the default locale, which is 
  # what we fallback to when the slug is not available in our desired
  # locale.
  def assign_path
    self.path = "/#{self.slug}"
  end

end
