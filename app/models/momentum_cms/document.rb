class MomentumCms::Document < MomentumCms::Entry
  # == MomentumCms ==========================================================
  # == Constants ============================================================
  # == Relationships ========================================================
  belongs_to :blue_print
  # == Extensions ===========================================================
  # == Validations ==========================================================
  # == Scopes ===============================================================
  # == Callbacks ============================================================
  before_validation :assign_layout_from_document
  # == Class Methods ========================================================
  # == Instance Methods =====================================================
  protected
  def assign_layout_from_document
    self.layout = self.document
  end

end
