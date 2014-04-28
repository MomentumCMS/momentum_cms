class CreateMomentumCmsPages < ActiveRecord::Migration

  def up
    create_table :momentum_cms_pages do |t|
      t.references :site, index: true
      t.string :label
      t.integer :published_content_id
      t.string :ancestry

      t.string :slug
      t.string :path

      t.timestamps
    end
  end

  def down
    drop_table :momentum_cms_pages
  end

end