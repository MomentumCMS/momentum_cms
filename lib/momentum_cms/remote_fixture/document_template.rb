module MomentumCms
  module RemoteFixture
    module DocumentTemplate
      class Importer < Base::Importer
        def import!
          document_template = @remote_fixture_object['documents']
          document_template.each do |document_template_identifier, document_template_meta|
            document_template = MomentumCms::DocumentTemplate.for_site(@site).where(identifier: document_template_identifier).first_or_initialize
            label = document_template_meta.fetch('label', nil)
            case label
              when Hash
                original_locale = I18n.locale
                label.each do |locale, value|
                  begin
                    I18n.locale = locale
                    document_template.label = value
                    document_template.save

                  rescue I18n::InvalidLocale
                  end
                end
                I18n.locale = original_locale
              when String
                document_template.label = label
                document_template.save
            end

            fields = document_template_meta.fetch('fields', nil)
            fields.each do |field_identifier, field_meta|
              field_template = MomentumCms::FieldTemplate.where(document_template: document_template, identifier: field_identifier).first_or_initialize
              label = field_meta.fetch('label', nil)
              case label
                when Hash
                  original_locale = I18n.locale
                  label.each do |locale, value|
                    begin
                      I18n.locale = locale
                      field_template.label = value
                      field_template.save
                    rescue I18n::InvalidLocale
                    end
                  end
                  I18n.locale = original_locale
                when String
                  field_template.label = label
                  field_template.save
              end
              field_template.field_value_type = field_meta['type']
              field_template.save
            end
          end

          document_template_hierarchy = @remote_fixture_object['document-hierarchy']
          assign_document_parent!(document_template_hierarchy)
        end

        def assign_document_parent!(set = nil, parent=nil)
          set.each do |key, value|
            document_template = MomentumCms::DocumentTemplate.for_site(@site).where(identifier: key).first
            if parent
              document_template.parent = parent
              document_template.save
            end
            if value
              assign_document_parent!(value, document_template)
            end
          end
        end

      end
    end
  end
end
