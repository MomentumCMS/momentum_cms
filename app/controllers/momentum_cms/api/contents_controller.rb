class MomentumCms::Api::ContentsController < MomentumCms::BaseController

  respond_to :json
  before_action :load_momentum_cms_content, only: [:show]
  before_action :prepare_templates

  def show
    content = nil
    respond_with(@momentum_cms_content)
  end

  private
  def load_momentum_cms_content
    path = ("/#{params[:id]}" || '/').gsub('//', '/')

    @momentum_cms_page = MomentumCms::Page.for_site(@momentum_cms_site).where(path: path).first!
    @momentum_cms_content = @momentum_cms_page.published_content

  rescue ActiveRecord::RecordNotFound
    raise MomentumCms::RecordNotFound.new(path)
  end

  def prepare_templates
    @template_array = MomentumCms::Template.for_site(@momentum_cms_site).ancestor_and_self!(@momentum_cms_page.template)
  end
end
