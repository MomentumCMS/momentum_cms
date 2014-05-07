class MomentumCms::Admin::TemplatesController < MomentumCms::Admin::BaseController
  before_action :load_moment_cms_template, only: [:edit, :update, :destroy]
  before_action :build_moment_cms_template, only: [:new, :create]

  def index
    @momentum_cms_templates = MomentumCms::Template.all
  end

  def new
  end

  def edit
  end

  def create
    @momentum_cms_template.save!
    flash[:success] = 'Template was successfully created.'
    redirect_to action: :edit, :id => @momentum_cms_template
  rescue ActiveRecord::RecordInvalid
    render action: :new
  end

  def update
    @momentum_cms_template.update_attributes!(momentum_cms_template_params)
    flash[:success] = 'Template was successfully updated.'
    redirect_to action: :edit, :id => @momentum_cms_template
  rescue ActiveRecord::RecordInvalid
    render action: :edit
  end

  def destroy
    @momentum_cms_template.destroy
    flash[:success] = 'Template was successfully destroyed.'
    redirect_to action: :index
  end

  private
  def load_moment_cms_template
    @momentum_cms_template = MomentumCms::Template.find(params[:id])
  end

  def build_moment_cms_template
    @momentum_cms_template = MomentumCms::Template.new(momentum_cms_template_params)
  end

  def momentum_cms_template_params
    params.fetch(:momentum_cms_template, {}).permit!
  end
end