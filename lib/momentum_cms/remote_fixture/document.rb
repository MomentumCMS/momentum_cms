module MomentumCms
  module RemoteFixture
    module Document
      class Importer < Base::Importer
        def import!
          documents = @remote_fixture_object.fetch('documents', [])
          documents.each do |document|
            blue_print = MomentumCms::BluePrint.where(identifier: document.fetch('blue-print', nil)).first
            next unless blue_print
            cms_document = @site.documents.where(identifier: document.fetch('identifier', nil)).first_or_initialize
            cms_document.blue_print = blue_print
            cms_document.save
            label = document.fetch('label', nil)
            MomentumCms::RemoteFixture::Utils.import_localized_object(label, @site) do |value, locale|
              cms_document.update_attributes({ label: value })
            end
            fields = document.fetch('fields', [])
            fields.each do |blue_print_identifier, field_metas|
              field_metas.each do |identifier, field_value|
                cms_field = MomentumCms::Field.where(entry: cms_document, identifier: "#{MomentumCms::BluePrint.to_s}//#{blue_print_identifier}::#{identifier}").first_or_create! do |o|
                  o.field_template = MomentumCms::FieldTemplate.where(layout: MomentumCms::BluePrint.for_site(@site).where(identifier: blue_print_identifier).first, identifier: identifier).first!
                end
                MomentumCms::RemoteFixture::Utils.import_localized_object(field_value, @site) do |value, locale|
                  cms_field.update_attributes({ value: value })
                end

                cms_field.save!
              end
            end
          end
        end
      end
    end
  end
end
