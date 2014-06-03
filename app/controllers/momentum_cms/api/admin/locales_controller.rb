class MomentumCms::Api::Admin::LocalesController < MomentumCms::Api::Admin::BaseController

  def index
    render json: MomentumCms::Internationalization.available
  end

end