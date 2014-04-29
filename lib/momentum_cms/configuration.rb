class MomentumCms::Configuration

  # Sets the default locale for the CMS
  attr_accessor :default_locale

  # Configuration defaults
  def initialize
    default_locale = :en
  end

end