class CreateMomentumCmsBluePrints < ActiveRecord::Migration
  def up
    create_table :momentum_cms_blue_prints do |t|
      t.references :site, index: true
      t.string :identifier
      t.string :ancestry

      t.timestamps
    end
    MomentumCms::BluePrint.create_translation_table! label: :string
  end

  def down
    drop_table :momentum_cms_blue_prints
    MomentumCms::BluePrint.drop_translation_table!
  end
end

