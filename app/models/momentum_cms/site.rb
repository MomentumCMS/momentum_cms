class MomentumCms::Site < ActiveRecord::Base
  # == MomentumCms ==========================================================

  self.table_name = 'momentum_cms_sites'

  # == Constants ============================================================
  # == Relationships ========================================================

  has_many :pages,
           dependent: :destroy

  has_many :files,
           dependent: :destroy

  # == Extensions ===========================================================

  has_settings do |s|
    s.key :site, :defaults => { :title => 'Just another CMS' }
  end

  # == Validations ==========================================================

  validates :label, :host, presence: true

  # == Scopes ===============================================================
  # == Callbacks ============================================================
  # == Class Methods ========================================================
  # == Instance Methods =====================================================
end
