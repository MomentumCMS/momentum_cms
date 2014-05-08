require 'action_view'

class CmsJsTag < Liquid::Tag
  include ActionView::Helpers::AssetTagHelper

  def render(context)
    _cms_page    = context.environments.first
    _cms_page    =_cms_page[:cms_page]
    _cms_page_id = _cms_page.id
    javascript_include_tag "/momentum_cms/js/#{_cms_page_id}.js"
  rescue
    ''
  end
end

Liquid::Template.register_tag 'cms_js', CmsJsTag