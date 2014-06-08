class CreateMomentumCmsSites < ActiveRecord::Migration
  def change
    create_table :momentum_cms_sites do |t|
      t.string :identifier
      t.string :label
      t.string :host
      t.string :title
      t.text :available_locales
      t.string :default_locale
      t.boolean :enable_advanced_features, default: false
      t.string :remote_fixture_type
      t.text :remote_fixture_url
      t.datetime :last_remote_synced_at

      t.timestamps
    end
  end
end
