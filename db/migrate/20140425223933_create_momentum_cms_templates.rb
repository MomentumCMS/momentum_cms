class CreateMomentumCmsTemplates < ActiveRecord::Migration
  def change
    create_table :momentum_cms_templates do |t|
      t.string :label
      t.references :site, index: true
      t.text :value
      t.text :js
      t.text :css
      t.string :ancestry
      t.boolean :has_yield, default: false
      t.boolean :permanent_record, default: false

      t.timestamps
    end
  end
end
