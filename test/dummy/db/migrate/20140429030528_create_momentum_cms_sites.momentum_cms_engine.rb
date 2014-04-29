# This migration comes from momentum_cms_engine (originally 20140425223932)
class CreateMomentumCmsSites < ActiveRecord::Migration
  def change
    create_table :momentum_cms_sites do |t|
      t.string :label
      t.string :host

      t.timestamps
    end
  end
end
