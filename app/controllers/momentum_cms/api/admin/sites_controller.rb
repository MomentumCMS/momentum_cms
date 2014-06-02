class MomentumCms::Api::Admin::SitesController < MomentumCms::Api::Admin::BaseController

  def index
    @sites = MomentumCms::Site.all
    render json: @sites
  end

  def create
    @site = MomentumCms::Site.new(site_params)
    @site.save!
    render json: @site
  rescue ActiveRecord::RecordInvalid
    render json: { errors: @site.errors, status: 422 }, status: 422
  end

  def show
    @site = MomentumCms::Site.find(params[:id])
    render json: @site
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'Site not found', status: 422 }, status: 422
  end

  private

  def site_params
    params.fetch(:site, {}).permit(:title,
                                   :label,
                                   :identifier,
                                   :host,
                                   :default_locale,
                                   :available_locales)
  end

end