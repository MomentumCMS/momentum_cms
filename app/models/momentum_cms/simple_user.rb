class MomentumCms::SimpleUser < MomentumCms::Tableless
  has_many :api_keys,
           foreign_key: :user_id

  column :id, :integer
end