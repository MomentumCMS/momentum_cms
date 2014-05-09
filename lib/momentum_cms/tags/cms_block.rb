class CmsBlockTag < Liquid::Tag

  attr_accessor :params

  def initialize(tag_name, params, tokens)
    super
    @params = sanatize_params(params)
    @params = parse_params(params)
  end

  def sanatize_params(params)
    params = params.squeeze
    params = params.strip
    params
  end

  def parse_params(params)
    result = {}
    params.split(' ').each do |keyval|
      keyval = keyval.split(':')
      result[keyval[0].to_sym] = keyval[1]
    end
    result
  end


  def render(context)
    _env = context.environments.first
    _edit = _env[:_edit]
    _cms_content = _env[:cms_content]
    if _edit
    else
      block = _cms_content.blocks.where(identifier: @params[:id]).first
      block.value
    end
  rescue
    ''
  end
end

Liquid::Template.register_tag 'cms_block', CmsBlockTag