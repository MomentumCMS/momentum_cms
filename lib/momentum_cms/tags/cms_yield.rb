class CmsYieldTag < Liquid::Tag
  def render(context)
    _yield = context.environments.first
    _yield =_yield[:yield]
    _yield
  rescue
    ''
  end
end

Liquid::Template.register_tag 'cms_yield', CmsYieldTag