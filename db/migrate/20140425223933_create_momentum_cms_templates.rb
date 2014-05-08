class CreateMomentumCmsTemplates < ActiveRecord::Migration
  def change
    create_table :momentum_cms_templates do |t|
      t.string :label
      t.references :site, index: true
      t.text :content
      t.text :js
      t.text :css
      t.string :ancestry

      t.timestamps
    end
  end
end
