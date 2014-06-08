module MomentumCms
  module RemoteFixture
    module BluePrint
      class Importer < Base::Importer
        def import!
          blue_print = @remote_fixture_object['documents']
          blue_print.each do |blue_print_identifier, blue_print_meta|
            blue_print = MomentumCms::BluePrint.for_site(@site).where(identifier: blue_print_identifier).first_or_initialize
            label = blue_print_meta.fetch('label', nil)
            case label
              when Hash
                original_locale = I18n.locale
                label.each do |locale, value|
                  begin
                    I18n.locale = locale
                    blue_print.label = value
                    blue_print.save

                  rescue I18n::InvalidLocale
                  end
                end
                I18n.locale = original_locale
              when String
                blue_print.label = label
                blue_print.save
            end

            fields = blue_print_meta.fetch('fields', nil)
            fields.each do |field_identifier, field_meta|
              field_template = MomentumCms::FieldTemplate.where(layout: blue_print, identifier: field_identifier).first_or_initialize
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

          blue_print_hierarchy = @remote_fixture_object['document-hierarchy']
          assign_document_parent!(blue_print_hierarchy)
        end

        def assign_document_parent!(set = nil, parent=nil)
          set.each do |key, value|
            blue_print = MomentumCms::BluePrint.for_site(@site).where(identifier: key).first
            if parent
              blue_print.parent = parent
              blue_print.save
            end
            if value
              assign_document_parent!(value, blue_print)
            end
          end
        end

      end
    end
  end
end
