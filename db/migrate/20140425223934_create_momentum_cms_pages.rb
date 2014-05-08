class CreateMomentumCmsPages < ActiveRecord::Migration

  def up
    create_table :momentum_cms_pages do |t|
      t.references :site, index: true
      t.references :template, index: true
      t.string :label
      t.integer :published_content_id
      t.string :ancestry
      t.string :internal_path
      t.timestamps
    end
    MomentumCms::Page.create_translation_table! :slug => :string, :path => :string
  end

  def down
    drop_table :momentum_cms_pages
    MomentumCms::Page.drop_translation_table!
  end

end