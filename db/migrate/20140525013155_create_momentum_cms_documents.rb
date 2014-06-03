class CreateMomentumCmsDocuments < ActiveRecord::Migration
  def up
    create_table :momentum_cms_documents do |t|
      t.references :blue_print, index: true
      t.references :site, index: true
      t.string :identifier

      t.timestamps
    end
    MomentumCms::Document.create_translation_table! label: :string
  end

  def down
    drop_table :momentum_cms_documents
    MomentumCms::Document.drop_translation_table!
  end
end

