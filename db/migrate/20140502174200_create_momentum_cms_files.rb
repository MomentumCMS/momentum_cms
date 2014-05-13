class CreateMomentumCmsFiles < ActiveRecord::Migration
  def change
    create_table :momentum_cms_files do |t|
      t.string :label
      t.string :tag
      t.string :slug
      t.boolean :multiple, default: false
      t.references :site, index: true
      t.references :attachable, polymorphic: true
      t.timestamps
    end
    add_attachment :momentum_cms_files, :file
  end
end
