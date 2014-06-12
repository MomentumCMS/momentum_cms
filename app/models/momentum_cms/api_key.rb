class MomentumCms::ApiKey < ActiveRecord::Base

  # == MomentumCms ==========================================================
  include MomentumCms::BelongsToUser
  
  self.table_name = 'momentum_cms_api_keys'

  # == Relationships ========================================================
  # == Validations ==========================================================

  validates :scope,
            inclusion: { in: ['session', 'api'] }

  # == Scopes ===============================================================

  scope :session,
        -> {
          where(scope: 'session')
        }

  scope :api,
        -> {
          where(scope: 'api')
        }
  scope :active,
        -> {
          where('expired_at >= ?', Time.now)
        }

  # == Callbacks ============================================================

  before_create :generate_access_token,
                :set_expiry_date

  # == Class Methods ========================================================
  # == Instance Methods =====================================================

  protected

  def generate_access_token
    begin
      self.access_token = SecureRandom.hex
    end while self.class.exists?(access_token: access_token)
  end

  def set_expiry_date
    self.expired_at = if self.scope == 'api'
                        30.days.from_now
                      else
                        4.hours.from_now
                      end
  end

end
