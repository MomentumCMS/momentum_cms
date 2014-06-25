module MomentumCms
  module ActAsUser
    extend ActiveSupport::Concern

    included do
      # == MomentumCms ==========================================================
      # == Constants ============================================================
      # == Relationships ========================================================

      has_many :api_keys,
               foreign_key: :user_id

      has_many :site_users,
               dependent: :destroy

      has_many :sites,
               through: :site_users

      # == Extensions ===========================================================
      # == Validations ==========================================================
      # == Scopes ===============================================================
      # == Callbacks ============================================================
      # == Class Methods ========================================================
      # == Instance Methods =====================================================
    end

    module ClassMethods
    end
  end
end