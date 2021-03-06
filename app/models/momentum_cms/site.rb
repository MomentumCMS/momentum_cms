class MomentumCms::Site < ActiveRecord::Base
  # == MomentumCms ==========================================================
  include MomentumCms::HasFiles

  self.table_name = 'momentum_cms_sites'

  # == Constants ============================================================

  REMOTE_FIXTURE_TYPE = [
    'http',
    'ssh'
  ].freeze

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

  has_many :blue_prints,
           dependent: :destroy

  has_many :documents,
           dependent: :destroy

  has_many :site_users,
           dependent: :destroy

  has_many :users,
           through: :site_users

  # == Extensions ===========================================================

  serialize :available_locales

  # == Validations ==========================================================

  validates :label,
            :host,
            presence: true

  validates :identifier,
            presence: true,
            uniqueness: true

  validate :locale_settings

  # == Scopes ===============================================================
  # == Callbacks ============================================================

  before_validation :assign_identifier,
                    :assign_locales,
                    :assign_title,
                    :assign_remote_fixture_type

  # == Class Methods ========================================================
  # == Instance Methods =====================================================

  def get_locales
    self.available_locales
  end

  def sync_remote!
    if self.enable_advanced_features
      if self.remote_fixture_url.present?
        MomentumCms::RemoteFixture::Importer.new(source: self.remote_fixture_url, site: self).import!
        self.last_remote_synced_at = DateTime.now
        self.save!
      end
    end
  end

  def self.custom_attachable_styles
    {
      :'_100x100#' => '100x100#'
    }
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
    if self.available_locales.blank? && self.default_locale.blank?
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

  def assign_remote_fixture_type
    if self.enable_advanced_features
      if self.remote_fixture_type.blank?
        #TODO - Determine the type based on the link given
        # http://foobar
        # https://foobar
        # ssh://develop@bar
      end
    end
  end
end
