# This migration comes from momentum_cms_engine (originally 20140425223934)
class CreateMomentumCmsPages < ActiveRecord::Migration
  def change
    create_table :momentum_cms_pages do |t|
      t.references :site, index: true
      t.string :name
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.integer :depth
      t.timestamps
    end
  end
end
