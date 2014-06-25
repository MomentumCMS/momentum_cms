class MomentumCms::SimpleUser < MomentumCms::Tableless
  # == MomentumCms ==========================================================

  include MomentumCms::ActAsUser

  # == Constants ============================================================
  # == Relationships ========================================================
  # == Extensions ===========================================================

  column :id, :integer, 1
  column :username, :string, MomentumCms::Authentication::HttpAuthentication.username
  column :password, :string, MomentumCms::Authentication::HttpAuthentication.password

  # == Validations ==========================================================
  # == Scopes ===============================================================
  # == Callbacks ============================================================
  # == Class Methods ========================================================
  # == Instance Methods =====================================================
end