class MomentumCms::SiteSerializer < MomentumCms::ApplicationSerializer

  #-- Attributes ------------------------------------------------------------
  attributes :id,
             :identifier,
             :label,
             :host,
             :title,
             :available_locales,
             :default_locale,
             :created_at,
             :updated_at

end
