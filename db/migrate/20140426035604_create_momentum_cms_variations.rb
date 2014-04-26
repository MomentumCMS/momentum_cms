class CreateMomentumCmsVariations < ActiveRecord::Migration
  def change
    create_table :momentum_cms_variations do |t|
      t.references :page, index: true
      t.string :slug
      t.string :path
      t.string :title
      t.string :content

      t.timestamps
    end
  end
end
