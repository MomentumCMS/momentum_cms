class MomentumCms::Api::Admin::PagesController < MomentumCms::Api::Admin::BaseController

  before_action :load_site

  def index
    @pages = @site.pages.all
    render json: @pages
  end

  def create
    @page = @site.pages.build(page_params)
    @page.save!
    render json: @page
  rescue ActiveRecord::RecordInvalid
    render json: {errors: @page.errors, status: 422}, status: 422
  end

private

  def load_site
    @site = MomentumCms::Site.find(params[:site_id])
  end

  def page_params
    params.fetch(:page, {}).permit(:identifier, :slug, :label, :template_id)
  end

end