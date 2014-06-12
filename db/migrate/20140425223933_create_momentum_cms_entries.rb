class CreateMomentumCmsEntries < ActiveRecord::Migration
  def up
    create_table :momentum_cms_entries do |t|
      t.string :type

      t.references :template, index: true
      t.references :blue_print, index: true

      t.references :site, index: true
      t.references :layout, index: true
      t.string :identifier, index: true
      t.integer :redirected_entry_id, index: true
      t.string :ancestry
      t.boolean :published, default: false, index: true
      t.timestamps
    end
    MomentumCms::Entry.create_translation_table! slug: :string, path: :string, label: :string
  end

  def down
    drop_table :momentum_cms_entries
    MomentumCms::Entry.drop_translation_table!
  end

end