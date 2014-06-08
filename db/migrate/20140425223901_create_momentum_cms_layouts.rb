class CreateMomentumCmsLayouts < ActiveRecord::Migration
  def up
    create_table :momentum_cms_layouts do |t|
      t.references :site, index: true
      t.string :identifier
      t.string :ancestry
      t.boolean :permanent_record, default: false
      t.text :value
      t.text :admin_value
      t.text :js
      t.text :css
      t.boolean :has_yield, default: false

      t.timestamps
    end
    MomentumCms::Layout.create_translation_table! label: :string
  end

  def down
    drop_table :momentum_cms_layouts
    MomentumCms::Layout.drop_translation_table!
  end
end