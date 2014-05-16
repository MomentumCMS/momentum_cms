class CreateMomentumCmsSites < ActiveRecord::Migration
  def change
    create_table :momentum_cms_sites do |t|
      t.string :identifier
      t.string :label
      t.string :host

      t.string :setting_title
      t.text :setting_locales
      t.text :setting_default_locale

      t.timestamps
    end
  end
end
