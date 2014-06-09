class MomentumCms::Field < ActiveRecord::Base
  # == MomentumCms ==========================================================

  self.table_name = 'momentum_cms_fields'

  # == Constants ============================================================
  # == Relationships ========================================================

  belongs_to :entry

  belongs_to :field_template

  belongs_to :revision_field,
             class_name: 'MomentumCms::Field',
             primary_key: :id,
             foreign_key: :revision_field_id

  # == Extensions ===========================================================

  translates :value,
             fallbacks_for_empty_translations: true

  # == Validations ==========================================================
  # == Scopes ===============================================================

  scope :draft_fields,
        -> {
          where(field_type: 'draft')
        }

  scope :published_fields,
        -> {
          where(field_type: 'published')
        }

  # == Callbacks ============================================================

  before_validation :assign_field_type

  after_create :create_revision_field

  after_destroy :destroy_revision_field
  
  # == Class Methods ========================================================

  # == Instance Methods =====================================================

  def draft?
    self.field_type == 'draft'
  end

  def published?
    self.field_type == 'published'
  end

  protected

  def create_revision_field
    if self.draft?
      field = self.dup
      field.field_type = 'published'
      field.revision_field_id = self.id
      field.save
      self.revision_field_id = field.id
      self.save
    end
  end

  def destroy_revision_field
    if self.draft?
      self.revision_field.try(:destroy)
    end
  end

  def assign_field_type
    if self.field_type.blank?
      self.field_type = 'draft'
    end
  end
end