class MomentumCms::PageSerializer < MomentumCms::ApplicationSerializer

  #-- Attributes ------------------------------------------------------------
  attributes :id,
             :identifier,
             :label,
             :slug,
             :template_id,
             :created_at,
             :updated_at

end
