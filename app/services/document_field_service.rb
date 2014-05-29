class DocumentFieldService

  attr_accessor :document_template_ancestors
  attr_accessor :document_template

  def initialize(document_template)
    @document_template = document_template
    @document_template_ancestors = MomentumCms::DocumentTemplate.ancestor_and_self!(document_template)
  end

  def get_fields(list = self.document_template_ancestors.dup)
    fields = []
    list.each do |document_template|
      fields << document_template.field_templates.to_a
    end
    fields.flatten.compact
  end
end