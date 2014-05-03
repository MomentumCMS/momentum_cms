class MomentumCms::Configuration

  # The locale for the CMS
  attr_accessor :locale

  # The style of the admin panel
  # Options here are:
  # nil - No admin panel will be present
  # :simple - Simple HTML5 admin panel
  # :default - The default admin panel
  attr_accessor :admin_panel_style

  # The location to mount the admin panel
  attr_accessor :admin_panel_mount_point

  # The authentication method used to authenticate the user
  # Options here are:
  # nil - No authentication will be used, dangerous
  # :default - Built in form
  # :http_basic - http_basic_auth
  attr_accessor :authentication_method

  # Configuration defaults
  def initialize
    @locale                  = :en
    @admin_panel_style       = :simple
    @admin_panel_mount_point = '/admin'
    @authentication_method   = :default
  end

end