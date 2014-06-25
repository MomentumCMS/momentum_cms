module MomentumCms
  module BelongsToUser
    extend ActiveSupport::Concern

    included do
      # == MomentumCms ==========================================================
      # == Constants ============================================================
      # == Relationships ========================================================

      belongs_to :user,
                 class_name: MomentumCms.configuration.user_class.constantize

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