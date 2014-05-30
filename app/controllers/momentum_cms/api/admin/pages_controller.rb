class MomentumCms::Api::Admin::PagesController < MomentumCms::Api::Admin::BaseController

  before_action :load_site, only: [:index]

  def index
    @pages = @site.pages.all
    render json: @pages
  end

  def create
    @page = MomentumCms::Page.new(page_params)
    @page.save!
    render json: @page
  rescue ActiveRecord::RecordInvalid
    render json: {errors: @page.errors, status: 422}, status: 422
  end

  def update
    @page = MomentumCms::Page.find(params[:id])
    @page.update_attributes!(page_params)
    render json: @page
  rescue ActiveRecord::RecordInvalid
    render json: {errors: @page.errors, status: 422}, status: 422
  end

private

  def page_params
    params.fetch(:page, {}).permit(:identifier,
                                   :slug,
                                   :label,
                                   :template_id,
                                   :site_id)
  end

  def load_site
    @site = MomentumCms::Site.find(params[:site_id])
  end

end