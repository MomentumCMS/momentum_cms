class CreateMomentumCmsContents < ActiveRecord::Migration
  def up
    create_table :momentum_cms_contents do |t|
      t.boolean :default
      t.string :identifier
      t.references :page, index: true
      t.timestamps
    end
    MomentumCms::Content.create_translation_table! label: :string
  end

  def down
    drop_table :momentum_cms_contents
    MomentumCms::Content.drop_translation_table!
  end

end