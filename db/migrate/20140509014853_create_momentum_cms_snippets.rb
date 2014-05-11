class CreateMomentumCmsSnippets < ActiveRecord::Migration
  def up
    create_table :momentum_cms_snippets do |t|
      t.references :site, index: true
      t.string :label
      t.string :slug

      t.timestamps
    end
    MomentumCms::Snippet.create_translation_table! value: :text
  end

  def down
    drop_table :momentum_cms_snippets
    MomentumCms::Snippet.drop_translation_table!
  end
end