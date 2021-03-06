class MomentumCms::TemplateSerializer < MomentumCms::ApplicationSerializer

  #-- Attributes ------------------------------------------------------------
  attributes :id,
             :identifier,
             :label,
             :css,
             :js,
             :value,
             :admin_value,
             :site_id,
             :permanent_record,
             :created_at,
             :updated_at

end
