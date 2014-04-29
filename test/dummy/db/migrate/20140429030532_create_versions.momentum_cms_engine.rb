# This migration comes from momentum_cms_engine (originally 20140429015753)
class CreateVersions < ActiveRecord::Migration
  def change
    create_table :versions do |t|
      t.string   :item_type, :null => false
      t.integer  :item_id,   :null => false
      t.string   :event,     :null => false
      t.string   :whodunnit
      t.text     :object
      t.datetime :created_at
      t.string  :locale
    end
    add_index :versions, [:item_type, :item_id]
  end
end
