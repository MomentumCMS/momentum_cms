class MomentumCms::Api::V1::Admin::AssetsController < MomentumCms::Api::V1::Admin::BaseController

  before_action :load_site, only: [:index]
  before_action :load_page, only: [:update, :destroy]

  def index
    @assets = @site.assets.all
    render json: @assets
  end

  def create
    @asset = MomentumCms::Asset.new(asset_params)
    @asset.save!
    render json: @asset
  rescue ActiveRecord::RecordInvalid
    render json: {errors: @asset.errors, status: 422}, status: 422
  end

  def destroy
    @asset.destroy
    render json: @asset
  end

private

  def asset_params
    params.fetch(:asset, {}).permit(:title,
                                    :description,
                                    :tag)
  end

  def load_site
    @site = MomentumCms::Site.find(params[:site_id])
  end

  def load_asset
    @asset = MomentumCms::Asset.find(params[:id])
  end

end