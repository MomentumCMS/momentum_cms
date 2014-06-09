class LayoutFieldService

  attr_accessor :template_ancestors
  attr_accessor :template

  def initialize(template)
    @template = template
    @template_ancestors = MomentumCms::Template.ancestor_and_self!(template)

    @valid_template = Liquid::Template.parse(@template.value)
  rescue Liquid::SyntaxError
    @valid_template = nil
  end


  def build_momentum_cms_field(entry, revision = nil)

    field_templates = self.get_fields

    if revision
      # Get the current entry's existing saved fields
      momentum_cms_fields = entry.fields.draft_fields

      field_revisions = revision[:fields]
      field_translation_revisions = revision[:fields_translations]

      momentum_cms_fields.each do |field|
        field_revision = field_revisions.detect do |x|
          x['identifier'] == field.identifier
        end

        if field_revision
          translation_for_field = field_translation_revisions.find do |x|
            x['momentum_cms_field_id'] == field_revision['id'] && x['locale'] == I18n.locale.to_s
          end

          if translation_for_field
            field.update_attributes({value: translation_for_field['value']})
          else
            field.translations.where(locale: I18n.locale).destroy_all
          end
        else
          field.destroy
        end
      end

      momentum_cms_fields = entry.fields.draft_fields.reload
      field_revisions.each do |field_revision|
        field = momentum_cms_fields.where(field_template: field_revision['field_template_id'],
                                          identifier: field_revision['identifier']).first_or_initialize
        if field.new_record?
          field.save
          translation_for_field = field_translation_revisions.find do |x|
            x['momentum_cms_field_id'] == field_revision['id'] && x['locale'] == I18n.locale.to_s
          end

          field.update_attributes({value: translation_for_field['value']}) if translation_for_field

        end
      end
    end

    momentum_cms_fields = entry.fields.draft_fields
    # Build fields from each field_templates
    field_templates.each do |field_template|
      field = momentum_cms_fields.detect { |x| x.identifier == field_template.to_identifier && x.field_type == 'draft' }
      if field.nil?
        entry.fields.build(
            identifier: field_template.to_identifier,
            field_template_id: field_template.id
        )
      end
    end
  end


  def create_or_update_field_templates_for_self!(delete_orphan = true)
    created_field_templates = []
    self.each_node do |node|
      next unless node.is_a?(MomentumCms::Tags::CmsBlock)
      field_template = MomentumCms::FieldTemplate.where(layout: @template,
                                                        identifier: node.params['id']).first_or_create! do |o|
        o.field_value_type = node.params.fetch('type', nil)
      end

      MomentumCms::Fixture::Utils.each_locale_for_site(@template.site) do |locale|
        label = node.params_get(locale.to_s)
        field_template.update_attributes({label: label}) if label
      end
      created_field_templates << field_template
    end

    MomentumCms::FieldTemplate.where(layout: @template).where.not(id: created_field_templates.collect(&:id)).destroy_all if delete_orphan

    created_field_templates
  end

  def valid_liquid?
    !@valid_template.nil?
  end

  def each_node(template = self.template)
    node_list = if template
                  begin
                    liquid = Liquid::Template.parse(template.value)
                    liquid.root.nodelist
                  rescue Liquid::SyntaxError
                    []
                  end
                elsif @valid_template
                  @valid_template.root.nodelist
                else
                  []
                end
    node_list.each do |node|
      yield(node)
    end
  end

  def has_field?(type)
    has_field_type = false
    self.each_node do |node|
      if node.is_a?(type)
        has_field_type = true
      end
    end
    has_field_type
  end

  def get_fields(list = self.template_ancestors.dup)
    fields = []
    list.each do |template|
      fields << template.field_templates.to_a
    end
    fields.flatten.compact
  end

  def get_identifiers
    self.get_fields.collect(&:to_identifier)
  end
end