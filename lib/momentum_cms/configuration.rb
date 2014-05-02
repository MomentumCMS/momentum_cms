class MomentumCms::Configuration

  # Sets the default locale for the CMS
  attr_accessor :locale

  # Configuration defaults
  def initialize
    locale = :en
  end

end