class MomentumCms::Menu < ActiveRecord::Base
  # == MomentumCms ==========================================================
  
  include MomentumCms::BelongsToSite
  
  self.table_name = 'momentum_cms_menus'

  # == Constants ============================================================
  # == Relationships ========================================================

  has_many :menu_items,
           dependent: :destroy

  attr_accessor :menu_json

  # == Extensions ===========================================================

  # == Validations ==========================================================

  validates :label,
            :identifier,
            presence: true
  
  validates :identifier,
            uniqueness: true

  # == Scopes ===============================================================
  # == Callbacks ============================================================

  after_save :update_menu_items

  # == Class Methods ========================================================
  # == Instance Methods =====================================================
  protected

  def update_menu_items
    json = JSON.parse(self.menu_json)
    MenuBuilderService.new({ json: json, menu: self }).create_or_update!
  rescue

  end
end
