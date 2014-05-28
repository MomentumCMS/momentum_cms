class CreateMomentumCmsBlockTemplates < ActiveRecord::Migration
  def up
    create_table :momentum_cms_block_templates do |t|
      t.references :template, index: true
      t.string :identifier
      t.string :block_type
      t.string :block_value_type

      t.timestamps
    end
    MomentumCms::BlockTemplate.create_translation_table! label: :string
  end

  def down
    drop_table :momentum_cms_block_templates
    MomentumCms::BlockTemplate.drop_translation_table!
  end
end