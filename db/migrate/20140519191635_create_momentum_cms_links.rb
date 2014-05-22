class CreateMomentumCmsLinks < ActiveRecord::Migration
  def up
    create_table :momentum_cms_links do |t|
      t.references :site, index: true
      t.string :identifier
      t.string :url
      t.string :target

      t.timestamps
    end
    MomentumCms::Link.create_translation_table! label: :text, description: :text
  end

  def down
    drop_table :momentum_cms_links
    MomentumCms::Link.drop_translation_table!
  end
end
