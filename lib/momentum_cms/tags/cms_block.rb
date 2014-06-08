module MomentumCms
  module Tags

    class CmsBlock < CmsBaseTag
      def render(context)

        view_context = context_get(context, :view_context, :frontend)

        cms_page = context_get!(context, :cms_page)

        cms_template = context_get(context, :cms_template)

        id = params_get!('id')

        block = if cms_template
                  cms_page.blocks.published_blocks.where(identifier: "#{cms_template.identifier}::#{id}").first
                else
                  cms_page.blocks.published_blocks.where(identifier: id).first
                end
        raise CmsTagError.new('Block not found') unless block

        if view_context == :admin
          k = rand(1000000...10000000)
          <<-ruby
<div class="block">
  <div class="form-group hidden momentum_cms_page_blocks_identifier"><div><input class="hidden form-control" id="momentum_cms_page_blocks_attributes_#{k}_identifier" name="momentum_cms_page[blocks_attributes][#{k}][identifier]" type="hidden" value="#{block.identifier}"></div></div>
  <div class="form-group hidden momentum_cms_page_blocks_field_template_id"><div><input class="hidden form-control" id="momentum_cms_page_blocks_attributes_#{k}_field_template_id" name="momentum_cms_page[blocks_attributes][#{k}][field_template_id]" type="hidden" value="#{block.field_template.id}"></div></div>
  <div class="form-group text optional momentum_cms_page_blocks_value"><label class="text optional control-label" for="momentum_cms_page_blocks_attributes_#{k}_value">#{block.identifier}</label><div><textarea class="text optional form-control" id="momentum_cms_page_blocks_attributes_#{k}_value" name="momentum_cms_page[blocks_attributes][#{k}][value]">#{block.value}</textarea></div></div>
</div>
          ruby
        else
          template = Liquid::Template.parse(block.value)
          template.render(context)
        end
      rescue => e
        print_error_message(e, self, context, @params)
      end
    end
    Liquid::Template.register_tag 'cms_block', CmsBlock
  end
end