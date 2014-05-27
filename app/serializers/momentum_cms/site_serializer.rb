class MomentumCms::SiteSerializer < ActiveModel::Serializer

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
