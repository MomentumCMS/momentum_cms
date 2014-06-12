class MomentumCms::Api::Admin::SitesController < MomentumCms::Api::Admin::BaseController

  before_action :load_site, only: [:show, :update, :destroy]

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

  def destroy
    @site.destroy
    render json: @site
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