class MomentumCms::Admin::SitesController < MomentumCms::Admin::BaseController
  skip_before_action :load_site, only: [:index, :new, :create, :edit, :update]
  before_action :load_momentum_cms_site, only: [:edit, :update, :destroy, :sync_remote]
  before_action :build_momentum_cms_site, only: [:new, :create]
  before_action :build_assets, only: [:new, :create, :edit, :update]

  def index
    @momentum_cms_sites = MomentumCms::Site.all
  end

  def new
  end

  def edit
  end

  def create
    @momentum_cms_site.save!
    flash[:success] = 'Site was successfully created.'
    redirect_to action: :edit, id: @momentum_cms_site
  rescue ActiveRecord::RecordInvalid
    render action: :new
  end

  def update
    @momentum_cms_site.update_attributes!(momentum_cms_site_params)
    flash[:success] = 'Site was successfully updated.'
    redirect_to action: :edit, id: @momentum_cms_site
  rescue ActiveRecord::RecordInvalid
    render action: :edit
  end

  def destroy
    @momentum_cms_site.destroy
    flash[:success] = 'Site was successfully destroyed.'
    redirect_to action: :index
  end


  def sync_remote
    if @momentum_cms_site.enable_advanced_features
      @momentum_cms_site.sync_remote!
      flash[:success] = 'Site was successfully synched with the remote fixture file.'
    end

    redirect_to action: :edit
  end

  private
  def build_assets
    @momentum_cms_site.build_files_if_not_exist_by_tag('avatar',
                                                       site: @momentum_cms_site,
                                                       require_image: true)
  end

  def load_momentum_cms_site
    @momentum_cms_site = MomentumCms::Site.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to action: :index
  end

  def build_momentum_cms_site
    @momentum_cms_site = MomentumCms::Site.new(momentum_cms_site_params)
  end

  def momentum_cms_site_params
    params.fetch(:momentum_cms_site, {}).permit!
  end
end
