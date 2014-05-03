MomentumCms.configure do |config|

  # The default locale for the CMS
  config.locale      = :en

  # The default mounted admin panel
  # Options here are:
  #  :simple - Simple HTML5 admin panel
  # :default - The default admin panel
  #      nil - No admin panel will be present
  config.admin_panel = :simple
end
