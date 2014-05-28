class MomentumCms::Api::SessionsController < MomentumCms::Api::BaseController

  def create
    # TODO: Add a hook that uses the user model's login method
    mock_user = { id: 1, email: 'admin@momentum-cms.io' }
    api_key = MomentumCms::ApiKey.create(scope: 'api')
    mock_user[:api_key] = api_key
    render json: { user: mock_user }
  end

  def destroy
    render json: { status: 200, message: 'Logged out' }, status: 200
  end

  private

  def session_params
    params.fetch(:session, {}).permit(:email, :password, :remember_me)
  end

end