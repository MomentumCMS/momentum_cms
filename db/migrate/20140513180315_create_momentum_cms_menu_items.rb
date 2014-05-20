class CreateMomentumCmsMenuItems < ActiveRecord::Migration
  def change
    create_table :momentum_cms_menu_items do |t|
      t.references :menu, index: true
      t.string :ancestry
      t.integer :menu_item_type
      t.integer :linkable_id
      t.string :linkable_type

      t.timestamps
    end
  end
end
