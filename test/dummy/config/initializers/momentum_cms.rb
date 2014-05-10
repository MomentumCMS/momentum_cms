MomentumCms.configure do |config|

  # The default locale
  config.locale = :en

  # Path where your site fixtures are located.
  #   config.site_fixtures_path = File.expand_path('db/cms_fixtures', Rails.root)
  config.site_fixtures_path = File.expand_path('sites', Rails.root)

  # Reload fixtures every request
  config.site_fixtures_enabled = false

  if Rails.env.test?
    config.site_fixtures_enabled = false
  end

end
