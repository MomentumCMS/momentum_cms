class MomentumCms::ApiKey < ActiveRecord::Base

  # == MomentumCms ==========================================================

  self.table_name = 'momentum_cms_api_keys'

  # == Relationships ========================================================
  # TODO: This should be configured
  # belongs_to :user

  # == Validations ==========================================================
  validates :scope, inclusion: { in: %w( session api ) }

  # == Scopes ===============================================================
  scope :session, -> { where(scope: 'session') }
  scope :api,     -> { where(scope: 'api') }
  scope :active,  -> { where('expired_at >= ?', Time.now) }

  # == Callbacks ============================================================
  before_create :generate_access_token, :set_expiry_date

  # == Class Methods ========================================================
  # == Instance Methods =====================================================
  def generate_access_token
    begin
      self.access_token = SecureRandom.hex
    end while self.class.exists?(access_token: access_token)
  end

  def set_expiry_date
    expires_at = 4.hours.from_now
    if self.scope == 'api'
      expires_at = 30.days.from_now
    end
    self.expired_at = expires_at
  end

end
