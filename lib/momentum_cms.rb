require 'haml-rails'
require 'sass-rails'
require 'ancestry'
require 'globalize'
require 'paper_trail'
require 'globalize-versioning'


require 'momentum_cms/engine'
require 'momentum_cms/error'
require 'momentum_cms/configuration'

module MomentumCms
  class << self

    # Call this method to modify your configuration
    # Example:
    #   MomentumCms.configure do |config|
    #     config.locale = :en
    #   end

    def configure
      yield configuration
    end

    # Accessor for the PostageApp::Configuration object
    # Example use:
    #   MomentumCms.configuration.locale = :en
    def configuration
      @configuration ||= Configuration.new
    end
    alias :config :configuration
    
    
  end
  
end
