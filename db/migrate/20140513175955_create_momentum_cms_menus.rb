class CreateMomentumCmsMenus < ActiveRecord::Migration
  def change
    create_table :momentum_cms_menus do |t|
      t.references :site, index: true
      t.string :label
      t.string :slug

      t.timestamps
    end
  end
end
