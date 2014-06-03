class MomentumCms::DocumentSerializer < MomentumCms::ApplicationSerializer

  #== Attributes ============================================================
  attributes :id,
             :identifier,
             :label,
             :blue_print_id,
             :created_at,
             :updated_at,
             :raw_fields

  has_many :fields

  def raw_fields
    fields = {}
    self.fields.collect { |field| fields[field.identifier] = field.value }
    fields
  end
end
