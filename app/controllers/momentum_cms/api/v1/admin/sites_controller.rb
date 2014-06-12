class MomentumCms::Api::V1::Admin::SitesController < MomentumCms::Api::V1::Admin::BaseController

  before_action :load_site, only: [:show, :update]

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
    render json: @site
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'Site not found', status: 422 }, status: 422
  end

  def update
    @site.update_attributes!(site_params)
    render json: @site
  rescue ActiveRecord::RecordInvalid
    render json: {errors: @site.errors, status: 422}, status: 422
  end

  private

  def site_params
    params.fetch(:site, {}).permit(:title,
                                   :label,
                                   :identifier,
                                   :host,
                                   :default_locale,
                                   available_locales: [])
  end

  def load_site
    @site = MomentumCms::Site.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { status: 404, message: 'Site not found' }, status: 404
  end

end