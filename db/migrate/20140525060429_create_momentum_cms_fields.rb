class CreateMomentumCmsFields < ActiveRecord::Migration
  def up
    create_table :momentum_cms_fields do |t|
      t.references :document, index: true
      t.references :field_template, index: true

      t.timestamps
    end

    MomentumCms::Field.create_translation_table! value: :text
  end

  def down
    drop_table :momentum_cms_fields
    MomentumCms::Field.drop_translation_table!
  end
end
