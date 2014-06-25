class MomentumCms::Api::V1::Admin::FilesController < MomentumCms::Api::V1::Admin::BaseController

  before_action :load_site, only: [:index]
  before_action :load_page, only: [:update, :destroy]

  def index
    @files = @site.files.all
    render json: @files
  end

  def create
    @file = MomentumCms::File.new(file_params)
    @file.save!
    render json: @file
  rescue ActiveRecord::RecordInvalid
    render json: { errors: @file.errors, status: 422 }, status: 422
  end

  def destroy
    @file.destroy
    render json: @file
  end

  private

  def file_params
    params.fetch(:file, {}).permit(:title,
                                   :description,
                                   :tag)
  end

  def load_site
    @site = MomentumCms::Site.find(params[:site_id])
  end

  def load_file
    @file = MomentumCms::File.find(params[:id])
  end

end