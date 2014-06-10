module MomentumCms
  module Tags

    class CmsField < CmsBaseTag
      def render(context)

        view_context = context_get(context, :view_context, :frontend)

        cms_page = context_get!(context, :cms_page)

        cms_template = context_get(context, :cms_template)

        id = params_get!('id')

        field = if cms_template
                  cms_page.fields.published_fields.where(identifier: "#{MomentumCms::Template}//#{cms_template.identifier}::#{id}").first
                else
                  cms_page.fields.published_fields.where(identifier: id).first
                end
        raise CmsTagError.new('Block not found') unless field

        if view_context == :admin
          k = rand(1000000...10000000)
          <<-ruby
<div class="field">
  <div class="form-group hidden momentum_cms_page_fields_identifier"><div><input class="hidden form-control" id="momentum_cms_page_fields_attributes_#{k}_identifier" name="momentum_cms_page[fields_attributes][#{k}][identifier]" type="hidden" value="#{field.identifier}"></div></div>
  <div class="form-group hidden momentum_cms_page_fields_field_template_id"><div><input class="hidden form-control" id="momentum_cms_page_fields_attributes_#{k}_field_template_id" name="momentum_cms_page[fields_attributes][#{k}][field_template_id]" type="hidden" value="#{field.field_template.id}"></div></div>
  <div class="form-group text optional momentum_cms_page_fields_value"><label class="text optional control-label" for="momentum_cms_page_fields_attributes_#{k}_value">#{field.identifier}</label><div><textarea class="text optional form-control" id="momentum_cms_page_fields_attributes_#{k}_value" name="momentum_cms_page[fields_attributes][#{k}][value]">#{field.value}</textarea></div></div>
</div>
          ruby
        else
          template = Liquid::Template.parse(field.value)
          template.render(context)
        end
      rescue => e
        print_error_message(e, self, context, @params)
      end
    end
    Liquid::Template.register_tag 'cms_field', CmsField
  end
end