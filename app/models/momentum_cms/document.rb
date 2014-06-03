class MomentumCms::Document < ActiveRecord::Base
  # == MomentumCms ==========================================================

  include MomentumCms::BelongsToSite

  self.table_name = 'momentum_cms_documents'

  # == Constants ============================================================
  # == Relationships ========================================================

  belongs_to :blue_print

  has_many :fields,
           inverse_of: :document,
           dependent: :destroy

  accepts_nested_attributes_for :fields

  has_many :revisions,
           as: :revisable,
           dependent: :destroy

  accepts_nested_attributes_for :revisions

  # == Extensions ===========================================================
  
  translates :label, fallbacks_for_empty_translations: true

  # == Validations ==========================================================

  validates :identifier, uniqueness: { scope: :site } , presence: true

  validates :blue_print,
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

  def publish!
    self.update_attributes(published: true)
    revision = {}
    revision[:document] = self.attributes
    revision[:document_translation] = self.translations.to_a.collect(&:attributes)
    revision[:fields] = []
    revision[:fields_translations] = []
    self.fields.draft_fields.each do |field|
      revision[:fields] << field.attributes
      revision[:fields_translations] << field.translations.to_a.collect(&:attributes)
    end
    revision[:fields].flatten!
    revision[:fields_translations].flatten!
    MomentumCms::Revision.publish_and_create_draft_for!(self, revision)

    self.fields.draft_fields.each do |field|
      published_field = field.revision_field
      MomentumCms::Fixture::Utils.each_locale_for_site(self.site) do |locale|
        published_field.value = field.value
        published_field.save!
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
end
