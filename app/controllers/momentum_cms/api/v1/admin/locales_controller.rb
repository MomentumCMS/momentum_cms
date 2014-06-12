class MomentumCms::Api::V1::Admin::LocalesController < MomentumCms::Api::V1::Admin::BaseController

  def index
    render json: MomentumCms::Internationalization.available
  end

end