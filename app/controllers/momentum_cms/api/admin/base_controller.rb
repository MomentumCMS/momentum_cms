class MomentumCms::Api::Admin::BaseController < ApplicationController

  skip_before_filter :verify_authenticity_token

  include MomentumCms::I18nLocale
  include MomentumCms.configuration.api_admin_authentication.to_s.constantize
  include MomentumCms.configuration.api_cors_header.to_s.constantize

  before_action :authenticate

end