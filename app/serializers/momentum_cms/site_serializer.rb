class MomentumCms::SiteSerializer < MomentumCms::ApplicationSerializer

  #-- Attributes ------------------------------------------------------------
  attributes :id,
             :identifier,
             :label,
             :host,
             :title,
             :available_locales,
             :default_locale,
             :enable_advanced_features,
             :remote_fixture_type,
             :remote_fixture_url,
             :remote_fixture_url,
             :created_at,
             :updated_at
  
  has_many :files

end
