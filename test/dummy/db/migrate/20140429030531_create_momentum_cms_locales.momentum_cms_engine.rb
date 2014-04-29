# This migration comes from momentum_cms_engine (originally 20140426214053)
class CreateMomentumCmsLocales < ActiveRecord::Migration
  def change
    create_table :momentum_cms_locales do |t|
      t.string :label
      t.string :identifier
    end
  end
end
