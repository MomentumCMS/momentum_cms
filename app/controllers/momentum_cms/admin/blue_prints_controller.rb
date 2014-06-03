class MomentumCms::Admin::BluePrintsController < MomentumCms::Admin::BaseController
  before_action :build_momentum_cms_blue_print, only: [:new, :create]
  before_action :load_momentum_cms_blue_print, only: [:edit, :update, :destroy]
  before_action :load_momentum_cms_blue_prints, only: [:index, :new, :create]
  before_action :load_parent_blue_prints, only: [:edit, :update]

  def index
  end

  def new
  end

  def edit
  end

  def create
    @momentum_cms_blue_print.save!
    flash[:success] = 'Document template was successfully created.'
    redirect_to action: :edit, :id => @momentum_cms_blue_print
  rescue ActiveRecord::RecordInvalid
    render action: :new
  end

  def update
    @momentum_cms_blue_print.update_attributes!(momentum_cms_blue_print_params)
    flash[:success] = 'Document template was successfully updated.'
    redirect_to action: :edit, :id => @momentum_cms_blue_print
  rescue ActiveRecord::RecordInvalid
    render action: :edit
  end

  def destroy
    @momentum_cms_blue_print.destroy
    flash[:success] = 'Document template was successfully destroyed.'
    redirect_to action: :index
  end

  private
  def load_momentum_cms_blue_print
    @momentum_cms_blue_print = MomentumCms::BluePrint.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to action: :index
  end

  def load_momentum_cms_blue_prints
    @momentum_cms_blue_prints = @current_momentum_cms_site.blue_prints.all
  end

  def load_parent_blue_prints
    @momentum_cms_blue_prints = @current_momentum_cms_site.blue_prints.where.not(id: @momentum_cms_blue_print.subtree_ids)
  end


  def build_momentum_cms_blue_print
    @momentum_cms_blue_print = MomentumCms::BluePrint.new(momentum_cms_blue_print_params)
    @momentum_cms_blue_print.site = @current_momentum_cms_site
  end

  def momentum_cms_blue_print_params
    params.fetch(:momentum_cms_blue_print, {}).permit!
  end
end
