class MomentumCms::Revision < ActiveRecord::Base

  # == MomentumCms ==========================================================

  self.table_name = 'momentum_cms_revisions'

  # == Constants ============================================================
  # == Relationships ========================================================

  belongs_to :revisable, polymorphic: true

  # == Extensions ===========================================================

  serialize :revision_data

  # == Validations ==========================================================

  # == Scopes ===============================================================

  default_scope { order(revision_number: :desc) }

  # == Callbacks ============================================================

  before_save :assign_published_status,
              :assign_revision_number

  def assign_published_status
    if self.published_status.blank?
      self.published_status = 'draft'
    end
  end

  def assign_revision_number
    if self.revision_number.blank?
      self.revision_number = self.revisable.revisions.length + 1
    end
  end

  # == Class Methods ========================================================
  def self.unpublish_for!(object)
    object.revisions.where(published_status: 'published').update_all(published_status: 'revision')
  end

  def self.create_draft_for!(object)
    object.revisions.create!
  end

  def self.build_draft_for!(object)
    object.revisions.build
  end

  def self.publish_and_create_draft_for!(object, revision_data = nil)
    object.revisions.where(published_status: 'published').update_all(published_status: 'revision')
    last_revision = object.revisions.first
    if last_revision && last_revision.published_status != 'published'
      last_revision.revision_data = revision_data
      last_revision.published_status = 'published'
      last_revision.save!
    end
    object.revisions.create!
  end

  # == Instance Methods =====================================================

  def revision?
    self.published_status == 'revision'
  end

  def published?
    self.published_status == 'published'
  end

  def draft?
    self.published_status == 'draft'
  end

end
