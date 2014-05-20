class CreateMomentumCmsMenus < ActiveRecord::Migration
  def change
    create_table :momentum_cms_menus do |t|
      t.references :site, index: true
      t.string :label
      t.string :identifier

      t.timestamps
    end
  end
end
