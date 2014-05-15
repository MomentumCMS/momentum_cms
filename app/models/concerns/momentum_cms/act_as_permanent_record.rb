module MomentumCms
  module ActAsPermanentRecord
    extend ActiveSupport::Concern

    included do
      # == MomentumCms ==========================================================
      # == Constants ============================================================
      # == Relationships ========================================================
      # == Extensions ===========================================================
      # == Validations ==========================================================

      validate :valid_liquid_content

      # == Scopes ===============================================================
      # == Callbacks ============================================================

      before_destroy :ensure_can_delete_record, prepend: true

      # == Class Methods ========================================================
      # == Instance Methods =====================================================

      private
      def valid_liquid_content
        
      end

      def ensure_can_delete_record
        if self.has_attribute?(:permanent_record) && self.permanent_record
          errors[:base] << "can not delete this record"
          raise PermanentObject.new('Can not delete this permanent record')
          false
        end
      end
    end

    module ClassMethods
    end
  end
end