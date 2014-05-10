class MomentumCms::Site < ActiveRecord::Base
  # == MomentumCms ==========================================================

  self.table_name = 'momentum_cms_sites'

  # == Constants ============================================================
  # == Relationships ========================================================

  has_many :pages,
           dependent: :destroy

  has_many :files,
           dependent: :destroy

  has_many :templates,
           dependent: :destroy

  has_many :snippets,
           dependent: :destroy

  # == Extensions ===========================================================

  has_settings do |s|
    s.key :site, :defaults => { :title => 'Just another CMS' }
    s.key :language
  end

  # == Validations ==========================================================

  validates :label, :host, :identifier, presence: true

  validates :identifier, uniqueness: true

  # == Scopes ===============================================================
  # == Callbacks ============================================================

  before_validation :assign_identifier

  # == Class Methods ========================================================
  # == Instance Methods =====================================================

  def get_locales(defaults=[])
    if self.settings(:language).locales.present?
      self.settings(:language).locales
    else
      defaults
    end
  end

  protected
  def assign_identifier
    if self.identifier.blank?
      self.identifier = SecureRandom.uuid
    end
  end
end
