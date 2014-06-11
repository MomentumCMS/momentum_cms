class MomentumCms::Admin::FilesController < MomentumCms::Admin::BaseController
  before_action :load_moment_cms_file, only: [:edit, :update, :destroy]
  before_action :build_moment_cms_file, only: [:new, :create]

  def index
    @momentum_cms_files = @current_momentum_cms_site.files
  end

  def new
  end

  def edit
  end

  def create
    @momentum_cms_file.save!
    flash[:success] = 'File was successfully created.'
    redirect_to action: :edit, id: @momentum_cms_file
  rescue ActiveRecord::RecordInvalid
    render action: :new
  end

  def update
    @momentum_cms_file.update_attributes!(momentum_cms_file_params)
    flash[:success] = 'File was successfully updated.'
    redirect_to action: :edit, id: @momentum_cms_file
  rescue ActiveRecord::RecordInvalid
    render action: :edit
  end

  def destroy
    @momentum_cms_file.destroy
    flash[:success] = 'File was successfully destroyed.'
    redirect_to action: :index
  end

  private
  def load_moment_cms_file
    @momentum_cms_file = MomentumCms::File.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to action: :index
  end

  def build_moment_cms_file
    @momentum_cms_file      = MomentumCms::File.new(momentum_cms_file_params)
    @momentum_cms_file.site = @current_momentum_cms_site
  end

  def momentum_cms_file_params
    params.fetch(:momentum_cms_file, {}).permit!
  end
end
