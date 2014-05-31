class CreateMomentumCmsApiKeys < ActiveRecord::Migration
  def change
    create_table :momentum_cms_api_keys do |t|
      t.integer :user_id, index: true
      t.string :access_token
      t.string :scope
      t.datetime :expired_at
      t.datetime :created_at
    end
    add_index :momentum_cms_api_keys, :access_token, unique: true
  end
end
