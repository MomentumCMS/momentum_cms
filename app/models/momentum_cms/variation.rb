class MomentumCms::Variation < ActiveRecord::Base

  # == MomentumCms ==========================================================

  self.table_name = 'momentum_cms_variations'

  # == Constants ============================================================
  # == Relationships ========================================================

  belongs_to :page

  # == Extensions ===========================================================
  # == Validations ==========================================================
  # == Scopes ===============================================================
  # == Callbacks ============================================================

  after_create :assign_path

  # == Class Methods ========================================================
  # == Instance Methods =====================================================

  protected
  def assign_path
    slugs = []
    self.page.self_and_ancestors.each do |page|
      # TODO: Need to find the variation with the same segments
      variation = page.variations.first
      if variation && variation.slug.present?
        slugs << if page.root?
                   nil
                 else
                   variation.slug
                 end
      end
    end
    slugs.compact!
    self.path = "/#{slugs.join('/')}"
    self.save
  end
end
