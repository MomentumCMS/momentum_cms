module MomentumCms
  module ActAsPermanentRecord
    extend ActiveSupport::Concern

    included do
      # == MomentumCms ==========================================================
      # == Constants ============================================================
      # == Relationships ========================================================
      # == Extensions ===========================================================
      # == Validations ==========================================================
      # == Scopes ===============================================================
      # == Callbacks ============================================================

      before_destroy :ensure_can_delete, prepend: true

      # == Class Methods ========================================================
      # == Instance Methods =====================================================

      private
      def ensure_can_delete
        if self.has_attribute?(:can_delete) && !self.can_delete
          errors[:base] << "can not delete this record"

          raise PermanentObject.new('Can not delete this record')

          false
        end
      end
    end

    module ClassMethods
    end
  end
end