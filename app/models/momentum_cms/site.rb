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

  has_many :menus,
           dependent: :destroy

  # == Extensions ===========================================================
  serialize :setting_locales, JSON
  serialize :setting_default_locale, JSON

  # == Validations ==========================================================

  validates :label, :host, :identifier, presence: true

  validates :identifier, uniqueness: true

  # == Scopes ===============================================================
  # == Callbacks ============================================================

  before_validation :assign_identifier

  # == Class Methods ========================================================
  # == Instance Methods =====================================================

  def get_locales(defaults=[])
    if self.setting_locales.present?
      self.setting_locales
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
