class MomentumCms::Admin::MenusController < MomentumCms::Admin::BaseController
  before_action :load_moment_cms_menu, only: [:edit, :update, :destroy]
  before_action :build_moment_cms_menu, only: [:new, :create]

  def index
    @momentum_cms_menus = @current_momentum_cms_site.menus.all
  end

  def new
  end

  def edit
  end

  def create
    @momentum_cms_menu.save!
    flash[:success] = 'Menu was successfully created.'
    redirect_to action: :edit, :id => @momentum_cms_menu
  rescue ActiveRecord::RecordInvalid
    render action: :new
  end

  def update
    @momentum_cms_menu.update_attributes!(momentum_cms_menu_params)
    flash[:success] = 'Menu was successfully updated.'
    redirect_to action: :edit, :id => @momentum_cms_menu
  rescue ActiveRecord::RecordInvalid
    render action: :edit
  end

  def destroy
    @momentum_cms_menu.destroy
    flash[:success] = 'Menu was successfully destroyed.'
    redirect_to action: :index
  end

  private
  def load_moment_cms_menu
    @momentum_cms_menu = MomentumCms::Menu.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to action: :index
  end

  def build_moment_cms_menu
    @momentum_cms_menu = MomentumCms::Menu.new(momentum_cms_menu_params)
    @momentum_cms_menu.site = @current_momentum_cms_site
  end

  def momentum_cms_menu_params
    params.fetch(:momentum_cms_menu, {}).permit!
  end
end
