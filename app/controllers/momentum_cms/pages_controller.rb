class MomentumCms::PagesController < MomentumCms::BaseController
  before_action :load_momentum_cms_page, only: [:show]
  before_action :load_momentum_cms_page_for_js_css, only: [:css, :js]
  before_action :prepare_templates
  
  skip_before_action :verify_authenticity_token, only: [:js]

  def css
    render :css, format: :css
  end

  def js
    render :js, format: :js
  end

  def show
    page = nil
    @template_array.reverse.each do |template|
      liquid = Liquid::Template.parse(template.value)
      page = liquid.render(yield: page,
                           cms_template: template,
                           cms_site: @momentum_cms_site,
                           cms_page: @momentum_cms_page)
    end
    render inline: page
  end

  private
  def load_momentum_cms_page
    path = ("/#{params[:id]}" || '/').gsub('//', '/')
    @momentum_cms_page = MomentumCms::Page.for_site(@momentum_cms_site).where(path: path).first!
  rescue ActiveRecord::RecordNotFound
    raise MomentumCms::RecordNotFound.new(path)
  end

  def load_momentum_cms_page_for_js_css
    @momentum_cms_page =MomentumCms::Page.for_site(@momentum_cms_site).where(id: params[:id]).first!
  rescue ActiveRecord::RecordNotFound
    raise MomentumCms::RecordNotFound.new("Page with id: #{params[:id]}")
  end

  def prepare_templates
    @template_array = MomentumCms::Template.for_site(@momentum_cms_site).ancestor_and_self!(@momentum_cms_page.template)
  end
end
