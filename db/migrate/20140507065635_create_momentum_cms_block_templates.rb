class CreateMomentumCmsBlockTemplates < ActiveRecord::Migration
  def change
    create_table :momentum_cms_block_templates do |t|
      t.references :template, index: true
      t.string :identifier
      t.string :block_type

      t.timestamps
    end
  end
end
