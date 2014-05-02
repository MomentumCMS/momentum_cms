class MomentumCms::Configuration

  # Sets the default locale for the CMS
  attr_accessor :locale

  # Sets the default path for site fixtures
  attr_accessor :site_fixtures_path

  # Enables site fixtures
  attr_accessor :site_fixtures_enabled

  # Configuration defaults
  def initialize
    locale = :en
    site_fixtures_path = File.expand_path('sites', Rails.root)
    site_fixtures_enabled = false
  end

end