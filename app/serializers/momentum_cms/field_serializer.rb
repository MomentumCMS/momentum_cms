class MomentumCms::FieldSerializer < MomentumCms::ApplicationSerializer

  #== Attributes ============================================================
  attributes :id,
             :field_template_id,
             :identifier,
             :value,
             :created_at,
             :updated_at
  
end
