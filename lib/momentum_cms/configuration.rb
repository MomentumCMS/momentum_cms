module MomentumCms
  class Configuration

    # The default locale for the CMS
    attr_accessor :locale

    # Sets the default path for site fixtures
    attr_accessor :site_fixtures_path

    # Enables site fixtures
    attr_accessor :site_fixtures_enabled

    attr_accessor :admin_authentication

    attr_accessor :api_admin_authentication

    attr_accessor :api_authentication

    # The style of the admin panel
    # Options here are:
    # nil - No admin panel will be present
    # :html5 - Simple HTML5 admin panel
    # :default - The default admin panel
    attr_accessor :admin_panel_style

    #The location to mount the api
    attr_accessor :api_mount_point

    # The location to mount the admin panel
    attr_accessor :admin_panel_mount_point

    # The location to mount the CMS
    attr_accessor :mount_point

    # The location to mount the CMS
    attr_accessor :api_mount_point

    # The authentication method used to authenticate the user
    # Options here are:
    # nil - No authentication will be used, dangerous
    # :default - Built in form
    # :http_basic - http_basic_auth
    attr_accessor :authentication_method

    # The amount of api end points to mount
    # :minimal or :full
    attr_accessor :api_level

    attr_accessor :api_cors_header
    
    attr_accessor :user_class

    # Configuration defaults
    def initialize
      @locale = 'en'
      @site_fixtures_path = File.expand_path('sites', Rails.root)
      @site_fixtures_enabled = false
      @enable_api = true
      @admin_panel_style = :html5
      @mount_point = '/'
      @api_mount_point = '/api'
      @admin_panel_mount_point = '/admin'
      @authentication_method = :default
      @admin_authentication = MomentumCms::Authentication::HttpAuthentication
      @api_admin_authentication = MomentumCms::Authentication::ApiAuthentication
      @api_authentication = MomentumCms::Authentication::NoAuthentication
      @api_cors_header = MomentumCms::Api::CorsHeaders
      @api_level = :minimal
      @user_class = 'MomentumCms::SimpleUser'
    end

  end
end

MomentumCms::Authentication::HttpAuthentication.username = 'username'
MomentumCms::Authentication::HttpAuthentication.password = 'password'