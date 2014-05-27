class MomentumCms::PageSerializer < ActiveModel::Serializer

  #-- Attributes ------------------------------------------------------------
  attributes :id,
             :identifier,
             :label,
             :slug,
             :template_id,
             :created_at,
             :updated_at

end
