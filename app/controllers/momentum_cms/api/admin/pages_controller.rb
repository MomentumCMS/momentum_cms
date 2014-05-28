class MomentumCms::Api::Admin::PagesController < MomentumCms::Api::BaseController

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

private

  def page_params
    params.fetch(:page, {}).permit(:identifier,
                                   :slug,
                                   :label,
                                   :template_id,
                                   :site_id)
  end

end