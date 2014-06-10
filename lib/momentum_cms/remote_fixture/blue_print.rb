module MomentumCms
  module RemoteFixture
    module BluePrint
      class Importer < Base::Importer
        def import!
          blue_print = @remote_fixture_object.fetch('blue-prints', [])
          blue_print.each do |blue_print_identifier, blue_print_meta|
            blue_print = MomentumCms::BluePrint.for_site(@site).where(identifier: blue_print_identifier).first_or_initialize
            label = blue_print_meta.fetch('label', nil)
            case label
              when Hash
                original_locale = I18n.locale
                label.each do |locale, value|
                  begin
                    I18n.locale = locale
                    blue_print.update_attributes({ label: value })
                  rescue I18n::InvalidLocale
                  end
                end
                I18n.locale = original_locale
              when String
                blue_print.update_attributes({ label: label })
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
                      field_template.update_attributes({ label: value })
                    rescue I18n::InvalidLocale
                    end
                  end
                  I18n.locale = original_locale
                when String
                  field_template.update_attributes({ label: label })
              end
              field_template.update_attributes({ field_value_type: field_meta['type'] })
            end
          end

          blue_print_hierarchy = @remote_fixture_object.fetch('blue-print-hierarchy', [])
          assign_document_parent!(blue_print_hierarchy)
        end

        def assign_document_parent!(set = nil, parent=nil)
          set.each do |key, value|
            blue_print = MomentumCms::BluePrint.for_site(@site).where(identifier: key).first
            if blue_print
              blue_print.update_attributes({ parent: parent }) if parent
              assign_document_parent!(value, blue_print) if value
            end
          end
        end

      end
    end
  end
end
