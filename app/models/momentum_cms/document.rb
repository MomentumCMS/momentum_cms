class MomentumCms::Document < MomentumCms::Entry
  # == MomentumCms ==========================================================
  # == Constants ============================================================
  # == Relationships ========================================================

  belongs_to :blue_print

  # == Extensions ===========================================================
  # == Validations ==========================================================
  # == Scopes ===============================================================
  # == Callbacks ============================================================

  before_validation :assign_layout_from_blue_print

  # == Class Methods ========================================================
  # == Instance Methods =====================================================

  protected

  def assign_layout_from_blue_print
    if self.layout.blank?
      self.layout = self.blue_print
    end
  end
end
