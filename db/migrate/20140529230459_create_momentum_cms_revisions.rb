class CreateMomentumCmsRevisions < ActiveRecord::Migration
  def change
    create_table :momentum_cms_revisions do |t|
      t.references :revisable, polymorphic: true
      t.integer :user_id, index: true
      t.integer :revision_number
      t.string :published_status
      t.text :revision_data
      t.timestamps
    end
    add_index :momentum_cms_revisions, [:revisable_id, :revisable_type], name: :momentum_cms_revisions_r_id_r_t
  end
end
