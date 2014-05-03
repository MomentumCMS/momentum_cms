class CreateMomentumCmsSettings < ActiveRecord::Migration
  def change
    create_table :momentum_cms_settings do |t|
      t.string :var, null: false
      t.text :value
      t.references :target, null: false, polymorphic: true
      t.timestamps
    end
    add_index :momentum_cms_settings, [:target_type, :target_id, :var], unique: true, name: 'momentum_cms_settings_uniq_ttype_tid_var'
  end
end
