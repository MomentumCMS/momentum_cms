class MomentumCms::ContentsController < MomentumCms::BaseController
  before_action :load_momentum_cms_content, only: [:show]

  before_action :load_momentum_cms_page, only: [:css, :js]
  before_action :prepare_templates


  def css
    render :css, format: :css
  end

  def js
    render :js, format: :js
  end

  def show
    content = @momentum_cms_content.content
    @template_array.reverse.each do |template|
      liquid  = Liquid::Template.parse(template.content)
      content = liquid.render(edit:        false,
                              yield:       content,
                              cms_page:    @momentum_cms_page,
                              cms_content: @momentum_cms_content)
    end
    render inline: content
  end

  private
  def load_momentum_cms_content
    path = "/#{params[:id]}" || '/'

    @momentum_cms_page    = MomentumCms::Page.where(path: path).first!
    @momentum_cms_content = @momentum_cms_page.contents.first

  rescue ActiveRecord::RecordNotFound
    raise MomentumCms::RecordNotFound.new(path)
  end

  def load_momentum_cms_page
    @momentum_cms_page = MomentumCms::Page.where(id: params[:id]).first!
  rescue ActiveRecord::RecordNotFound
    raise MomentumCms::RecordNotFound.new(path)
  end

  def prepare_templates
    template        = @momentum_cms_page.template
    @template_array = [template.ancestors.to_a, template].flatten.compact
  end

end
