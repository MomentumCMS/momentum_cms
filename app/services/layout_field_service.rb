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

  def find_field_translation_revision(field_translation_revisions, field_revision)
    field_translation_revisions.find do |field_translation_revision|
      field_translation_revision['momentum_cms_field_id'] == field_revision['id'] && field_translation_revision['locale'] == I18n.locale.to_s
    end
  end

  def get_revision_and_translation(revision)
    field_revisions = revision.fetch(:fields, [])
    field_translation_revisions = revision.fetch(:fields_translations, [])
    [field_revisions, field_translation_revisions]
  end

  def sync_entry_fields_with_revision(entry, revision)
    field_revisions, field_translation_revisions = self.get_revision_and_translation(revision)

    # Get the current entry's existing saved fields
    momentum_cms_fields = entry.fields.draft_fields.reload

    # Loop over all the entry's fields
    # This syncs the current existing entry's fields to the revisioned data
    momentum_cms_fields.each do |field|

      # Check to see if the revision data has the same identifier as the current field
      field_revision = field_revisions.detect do |field_revision|
        field_revision['identifier'] == field.identifier
      end

      # If there is a revision for the field...
      if field_revision
        # Find the translation for the block WRT the current locale
        translation_for_field = self.find_field_translation_revision(field_translation_revisions, field_revision)

        # If there are translations, then update the current locale with the value from the revision
        if translation_for_field
          field.update_attributes({value: translation_for_field['value']})
        else
          # There are no translations for this locale, so delete the locale translated value
          field.translations.where(locale: I18n.locale).destroy_all
        end
      else
        # Delete the current field, since this field (any translaitons did not exist when the revision was created)
        field.destroy
      end
    end
  end

  def sync_new_revision_fields_to_entry(entry, revision)
    field_revisions, field_translation_revisions = self.get_revision_and_translation(revision)

    # Now we need to check to see if there are fields from the revisions that the current entry do not have... and create those entries

    # Reload the fields...
    momentum_cms_fields = entry.fields.draft_fields.reload

    # Loop over each field in the revision data
    field_revisions.each do |field_revision|
      field = momentum_cms_fields.where(field_template: field_revision['field_template_id'],
                                        identifier: field_revision['identifier']).first_or_initialize

      # if the field does not exist, since we took care of the existing fields above
      if field.new_record?

        # Find the translation for the block WRT the current locale
        translation_for_field = self.find_field_translation_revision(field_translation_revisions, field_revision)

        if translation_for_field
          # Create the field
          field.save

          # Save the value if there are some translations
          field.update_attributes({value: translation_for_field['value']})
        end
      end
    end
  end

  def build_momentum_cms_field(entry, revision = nil)
    if revision
      self.sync_entry_fields_with_revision(entry, revision)
      self.sync_new_revision_fields_to_entry(entry, revision)
    end

    #Current fields for the entry
    momentum_cms_fields = entry.fields.draft_fields

    #Get all the fields from the field template, this is the list of fields that the current
    #layout (template, blue print) has, and needs to be created for the entry
    field_template_fields = self.get_fields
    field_template_fields.each do |field_template_field|

      # Try to find the draft field in the list of current fields for the entry
      field = momentum_cms_fields.detect do |momentum_cms_field|
        momentum_cms_field.identifier == field_template_field.to_identifier && momentum_cms_field.field_type == 'draft'
      end

      # Create the field for the entry if the field does not already exist
      unless field
        entry.fields.build(
            identifier: field_template_field.to_identifier,
            field_template_id: field_template_field.id
        )
      end
    end
  end

  def create_or_update_field_templates_for_self!(delete_orphan = true)
    created_field_templates = []

    self.each_node do |node|
      next unless node.is_a?(MomentumCms::Tags::CmsBlock)
      created_field_templates << self.create_or_update_field_template_from_tag(node)
    end
    MomentumCms::FieldTemplate.where(layout: @template).where.not(id: created_field_templates.collect(&:id)).destroy_all if delete_orphan

    created_field_templates
  end

  def create_or_update_field_template_from_tag(node)
    field_template = MomentumCms::FieldTemplate.where(layout: @template,
                                                      identifier: node.params['id']).first_or_create! do |o|
      o.field_value_type = node.params.fetch('type', nil)
    end

    MomentumCms::Fixture::Utils.each_locale_for_site(@template.site) do |locale|
      label = node.params_get(locale.to_s)
      field_template.update_attributes({label: label}) if label
    end
    field_template
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