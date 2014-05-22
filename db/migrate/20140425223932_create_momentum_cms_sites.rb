class CreateMomentumCmsSites < ActiveRecord::Migration
  def change
    create_table :momentum_cms_sites do |t|
      t.string :identifier
      t.string :label
      t.string :host

      t.string :title
      t.text :available_locales
      t.string :default_locale

      t.timestamps
    end
  end
end
