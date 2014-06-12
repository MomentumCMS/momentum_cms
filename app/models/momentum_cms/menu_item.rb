class MomentumCms::MenuItem < ActiveRecord::Base
  # == MomentumCms ==========================================================

  self.table_name = 'momentum_cms_menu_items'

  # == Constants ============================================================

  MENU_ITEM_TYPE = [
    INTERNAL = 0,
    EXTERNAL = 1
  ].freeze

  # == Relationships ========================================================

  belongs_to :linkable,
             polymorphic: true

  belongs_to :menu

  # == Extensions ===========================================================

  has_ancestry

  # == Validations ==========================================================

  validates :menu,
            presence: true

  # == Scopes ===============================================================

  scope :for_menu,
        ->(menu) {
          where(menu_id: menu.id)
        }

  scope :external,
        -> {
          where(menu_item_type: EXTERNAL)
        }

  scope :internal,
        -> {
          where(menu_item_type: INTERNAL)
        }

  # == Callbacks ============================================================

  before_validation :assign_menu_item_type

  # == Class Methods ========================================================
  # == Instance Methods =====================================================

  protected

  def assign_menu_item_type
    if self.linkable
      self.menu_item_type = INTERNAL
    else
      self.menu_item_type = EXTERNAL
    end
  end
end
