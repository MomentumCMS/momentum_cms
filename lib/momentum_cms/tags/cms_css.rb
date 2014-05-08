require 'action_view'

class CmsCssTag < Liquid::Tag
  include ActionView::Helpers::AssetTagHelper

  def render(context)
    _cms_page    = context.environments.first
    _cms_page    =_cms_page[:cms_page]
    _cms_page_id = _cms_page.id
    stylesheet_link_tag "/momentum_cms/css/#{_cms_page_id}.css"
  rescue
    ''
  end
end

Liquid::Template.register_tag 'cms_css', CmsCssTag
