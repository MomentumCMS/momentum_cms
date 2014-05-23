class MomentumCms::Api::BaseController < ApplicationController

  skip_before_filter :verify_authenticity_token

  include MomentumCms::I18nLocale
  include MomentumCms::Authentication::ApiAuthentication

end
