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
  after_save :regenerate_child_paths, if: :has_children?

  # == Class Methods ========================================================
  # == Instance Methods =====================================================

  def assign_path
    original_locale = I18n.locale
    self.translations.each do |translation|
      translated_path = []
      I18n.locale = translation.locale
      self.ancestors.each do |ancestor|
        translated_path << ancestor.slug
      end
      translated_path << self.slug
      self.path = "/#{translated_path.join('/')}"
    end
    I18n.locale = original_locale
  end

  def regenerate_child_paths
    descendants.each do |descendant|
      descendant.assign_path
      # translation = descendant.translations.where(locale: I18n.locale).first
      # puts "#{I18n.locale} --- #{translation.inspect}"
      # if translation
      #   translation.update_column(:path, descendant.path)
      # else
      # end
    end
  end

end
