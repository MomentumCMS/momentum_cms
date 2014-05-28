class CreateMomentumCmsDocumentTemplates < ActiveRecord::Migration
  def up
    create_table :momentum_cms_document_templates do |t|
      t.references :site, index: true
      t.string :identifier
      t.string :ancestry

      t.timestamps
    end
    MomentumCms::DocumentTemplate.create_translation_table! label: :string
  end

  def down
    drop_table :momentum_cms_document_templates
    MomentumCms::DocumentTemplate.drop_translation_table!
  end
end

