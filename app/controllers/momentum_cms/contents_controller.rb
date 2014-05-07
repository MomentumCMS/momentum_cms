class MomentumCms::ContentsController < MomentumCms::BaseController
  before_action :load_momentum_cms_content, only: [:show]

  def show
    @template = MomentumCms::Template.first
    content   = Liquid::Template.parse(@template.content)
    render inline: content.render
  end

  private
  def load_momentum_cms_content
    path = "/#{params[:id]}" || '/'

    @momentum_cms_page    = MomentumCms::Page.where(path: path).first!
    @momentum_cms_content = @momentum_cms_page.contents.first


  rescue ActiveRecord::RecordNotFound
    raise MomentumCms::RecordNotFound.new(path)
  end

end
