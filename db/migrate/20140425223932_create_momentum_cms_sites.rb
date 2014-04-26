class CreateMomentumCmsSites < ActiveRecord::Migration
  def change
    create_table :momentum_cms_sites do |t|
      t.string :label
      t.string :host

      t.timestamps
    end
  end
end
