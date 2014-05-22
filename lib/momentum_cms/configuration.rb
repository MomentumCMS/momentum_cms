module MomentumCms
  class Configuration

    # The default locale for the CMS
    attr_accessor :locale

    # Sets the default path for site fixtures
    attr_accessor :site_fixtures_path

    # Enables site fixtures
    attr_accessor :site_fixtures_enabled

    attr_accessor :admin_authentication

    # The style of the admin panel
    # Options here are:
    # nil - No admin panel will be present
    # :html5 - Simple HTML5 admin panel
    # :default - The default admin panel
    attr_accessor :admin_panel_style

    # The location to mount the admin panel
    attr_accessor :admin_panel_mount_point

    # The location to mount the CMS
    attr_accessor :mount_point

    # The authentication method used to authenticate the user
    # Options here are:
    # nil - No authentication will be used, dangerous
    # :default - Built in form
    # :http_basic - http_basic_auth
    attr_accessor :authentication_method

    # Configuration defaults
    def initialize
      @locale = 'en'
      @site_fixtures_path = File.expand_path('sites', Rails.root)
      @site_fixtures_enabled = false
      @admin_panel_style = :html5
      @mount_point = '/'
      @admin_panel_mount_point = '/admin'
      @authentication_method = :default
      @admin_authentication = MomentumCms::Authentication::HttpAuthentication
    end

  end
end

MomentumCms::Authentication::HttpAuthentication.username = 'username'
MomentumCms::Authentication::HttpAuthentication.password = 'password'