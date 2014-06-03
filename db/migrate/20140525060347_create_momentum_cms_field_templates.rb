class CreateMomentumCmsFieldTemplates < ActiveRecord::Migration
  def up
    create_table :momentum_cms_field_templates do |t|
      t.references :blue_print, index: true
      t.string :identifier
      t.string :field_value_type
      
      t.timestamps
    end
    MomentumCms::FieldTemplate.create_translation_table! label: :string
  end

  def down
    drop_table :momentum_cms_field_templates
    MomentumCms::FieldTemplate.drop_translation_table!
  end
end
