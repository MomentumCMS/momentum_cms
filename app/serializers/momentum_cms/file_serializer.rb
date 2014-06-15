class MomentumCms::FileSerializer < MomentumCms::ApplicationSerializer

  #-- Attributes ------------------------------------------------------------
  attributes :id,
             :label,
             :tag,
             :identifier,
             :multiple,
             :require_image,
             :site_id,
             :attachable_id,
             :attachable_type,
             :created_at,
             :updated_at,
             :file_file_name,
             :file_content_type,
             :file_file_size,
             :file_updated_at

end
