class MomentumCms::Entry < ActiveRecord::Base
# == MomentumCms ==========================================================

  include MomentumCms::BelongsToSite

  self.table_name = 'momentum_cms_entries'

  # == Constants ============================================================
  # == Relationships ========================================================

  belongs_to :layout

  has_many :fields,
           inverse_of: :entry,
           dependent: :destroy

  accepts_nested_attributes_for :fields

  has_many :revisions,
           as: :revisable,
           dependent: :destroy

  accepts_nested_attributes_for :revisions

  # == Extensions ===========================================================

  has_ancestry

  translates :label, :slug, :path, fallbacks_for_empty_translations: true

  # == Validations ==========================================================

  validates :identifier,
            presence: true,
            uniqueness: {scope: :site}

  validates :layout,
            presence: true

  # == Scopes ===============================================================

  scope :published,
        -> {
          where(published: true)
        }

  # == Callbacks ============================================================

  before_create :create_revision

  # == Class Methods ========================================================
  # == Instance Methods =====================================================

  def unpublish!
    self.update_attributes(published: false)
    MomentumCms::Revision.unpublish_for!(self)
  end

  def to_revision_data
    revision = {}
    revision[:entry] = self.attributes
    revision[:entry_translation] = self.translations.to_a.collect(&:attributes)
    revision[:fields] = []
    revision[:fields_translations] = []
    self.fields.draft_fields.each do |field|
      revision[:fields] << field.attributes
      revision[:fields_translations] << field.translations.to_a.collect(&:attributes)
    end
    revision[:fields].flatten!
    revision[:fields_translations].flatten!
    revision
  end

  def copy_draft_to_published_fields!
    self.fields.draft_fields.each do |field|
      published_field = field.revision_field
      MomentumCms::Fixture::Utils.each_locale_for_site(self.site) do |locale|
        published_field.update_attributes({value: field.value})
      end
    end
  end

  def publish!
    self.update_attributes(published: true)
    MomentumCms::Revision.publish_and_create_draft_for!(self, self.to_revision_data)
    self.copy_draft_to_published_fields!
  end

  def create_revision
    MomentumCms::Revision.build_draft_for!(self)
  end

  def published?
    !!self.published
  end

  protected
end
