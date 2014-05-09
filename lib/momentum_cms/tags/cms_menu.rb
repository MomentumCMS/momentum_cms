require 'action_view'

class CmsMenuTag < Liquid::Tag
  include ActionView::Helpers::AssetTagHelper

  def render(context)
    _cms_site = context.environments.first
    _cms_site =_cms_site[:cms_site]
  rescue
    ''
  end
end

Liquid::Template.register_tag 'cms_menu', CmsMenuTag