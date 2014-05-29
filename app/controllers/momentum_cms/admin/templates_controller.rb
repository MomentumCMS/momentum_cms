class MomentumCms::Admin::TemplatesController < MomentumCms::Admin::BaseController
  before_action :build_momentum_cms_template, only: [:new, :create]
  before_action :load_momentum_cms_template, only: [:edit, :update, :destroy]
  before_action :load_momentum_cms_templates, only: [:index, :new, :create]
  before_action :load_parent_templates, only: [:edit, :update]

  def index
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
    @momentum_cms_template.destroy!
    flash[:success] = 'Template was successfully destroyed.'
  rescue MomentumCms::PermanentObject
    flash[:warning] = 'Template was not destroyed.'
  ensure
    redirect_to action: :index
  end

  private
  def load_momentum_cms_template
    @momentum_cms_template = MomentumCms::Template.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to action: :index
  end

  def load_momentum_cms_templates
    @momentum_cms_templates = @current_momentum_cms_site.templates
  end

  def load_parent_templates
    @momentum_cms_templates = @current_momentum_cms_site.templates.has_yield.where.not(id: @momentum_cms_template.subtree_ids)
  end

  def build_momentum_cms_template
    @momentum_cms_template = MomentumCms::Template.new(momentum_cms_template_params)
    @momentum_cms_template.site = @current_momentum_cms_site
  end

  def momentum_cms_template_params
    params.fetch(:momentum_cms_template, {}).permit!
  end
end
