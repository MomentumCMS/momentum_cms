module MomentumCms
  module BelongsToSite
    extend ActiveSupport::Concern

    included do
      # == MomentumCms ==========================================================
      # == Constants ============================================================
      # == Relationships ========================================================

      belongs_to :site

      # == Extensions ===========================================================
      # == Validations ==========================================================

      validates :site,
                presence: true

      # == Scopes ===============================================================

      scope :for_site,
            ->(site) {
              where(site_id: site.id)
            }

      # == Callbacks ============================================================
      # == Class Methods ========================================================
      # == Instance Methods =====================================================
    end

    module ClassMethods
    end
  end
end