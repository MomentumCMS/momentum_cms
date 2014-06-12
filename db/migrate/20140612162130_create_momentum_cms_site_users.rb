class CreateMomentumCmsSiteUsers < ActiveRecord::Migration
  def change
    create_table :momentum_cms_site_users do |t|
      t.references :site, index: true
      t.references :user, index: true
      t.timestamps
    end
  end
end
