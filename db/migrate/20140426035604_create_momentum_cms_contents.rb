class CreateMomentumCmsContents < ActiveRecord::Migration
  def up
    create_table :momentum_cms_contents do |t|
      t.references :page, index: true
      t.string :label
      t.text :content

      t.timestamps
    end
  end

  def down
    drop_table :momentum_cms_contents
  end

end