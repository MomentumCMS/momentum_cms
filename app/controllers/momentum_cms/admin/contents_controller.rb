class MomentumCms::Admin::ContentsController < MomentumCms::Admin::BaseController
  before_action :load_moment_cms_page
  before_action :load_moment_cms_content, only: [:edit, :update, :destroy]
  before_action :build_moment_cms_content, only: [:new, :create]

  def index
    @momentum_cms_contents = @momentum_cms_page.contents.all
  end

  def new
  end

  def edit
  end

  def create
    @momentum_cms_content.save!
    flash[:success] = 'Content was successfully created.'
    redirect_to action: :edit, :id => @momentum_cms_content
  rescue ActiveRecord::RecordInvalid
    render action: :new
  end

  def update
    @momentum_cms_content.update_attributes!(momentum_cms_content_params)
    flash[:success] = 'Content was successfully updated.'
    redirect_to action: :edit, :id => @momentum_cms_content
  rescue ActiveRecord::RecordInvalid
    render action: :edit
  end

  def destroy
    @momentum_cms_content.destroy
    flash[:success] = 'Content was successfully destroyed.'
    redirect_to action: :index
  end

  private
  def load_moment_cms_page
    @momentum_cms_page = MomentumCms::Page.find(params[:page_id])
  end

  def load_moment_cms_content
    @momentum_cms_content = MomentumCms::Content.find(params[:id])
  end

  def build_moment_cms_content
    @momentum_cms_content      = MomentumCms::Content.new(momentum_cms_content_params)
    @momentum_cms_content.page = @momentum_cms_page
  end

  def momentum_cms_content_params
    params.fetch(:momentum_cms_content, {}).permit!
  end
end