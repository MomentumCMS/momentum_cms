class CreateMomentumCmsBlocks < ActiveRecord::Migration

  def up
    create_table :momentum_cms_blocks do |t|
      t.references :block_template, index: true
      t.references :page, index: true
      t.string :identifier
      t.timestamps
    end
    MomentumCms::Block.create_translation_table! value: :text
  end

  def down
    drop_table :momentum_cms_blocks
    MomentumCms::Block.drop_translation_table!
  end

end