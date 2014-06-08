class CreateMomentumCmsFields < ActiveRecord::Migration
  def up
    create_table :momentum_cms_fields do |t|
      t.references :entry, index: true
      t.references :field_template, index: true
      t.string :identifier    
      t.string :field_type
      t.integer :revision_field_id

      t.timestamps
    end

    MomentumCms::Field.create_translation_table! value: :text
  end

  def down
    drop_table :momentum_cms_fields
    MomentumCms::Field.drop_translation_table!
  end
end
