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
  serialize :available_locales

  # == Validations ==========================================================

  validates :label, :host, :identifier, presence: true

  validates :identifier, uniqueness: true

  validate :locale_settings

  # == Scopes ===============================================================
  # == Callbacks ============================================================

  before_validation :assign_identifier,
                    :assign_locales,
                    :assign_title

  # == Class Methods ========================================================
  # == Instance Methods =====================================================

  def get_locales(defaults=[])
    if self.available_locales.present?
      self.available_locales
    else
      defaults
    end
  end

  protected

  def locale_settings
    if self.available_locales && self.default_locale
      unless self.available_locales.include?(self.default_locale)
        self.errors.add(:default_locale, 'can not contain a locale that is not in the available locales list')
      end
    end
  end

  def assign_locales
    if (self.available_locales.nil? || self.available_locales.empty?) &&
      (self.default_locale.nil? || self.default_locale.empty?)
      self.available_locales = [MomentumCms.configuration.locale.to_s]
      self.default_locale = MomentumCms.configuration.locale.to_s
    end
    true
  end

  def assign_identifier
    if self.identifier.blank?
      self.identifier = SecureRandom.uuid
    end
    true
  end

  def assign_title
    if self.title.blank?
      self.title = 'MomentumCMS'
    end
    true
  end
end
