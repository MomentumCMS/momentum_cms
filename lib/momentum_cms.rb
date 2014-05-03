require 'jquery-rails'
require 'haml-rails'
require 'sass-rails'
require 'ancestry'
require 'globalize'
require 'paper_trail'
require 'globalize-versioning'
require 'fileutils'
require 'json'

require 'paperclip'
require 'simple_form'
require 'momentum_cms/engine'
require 'momentum_cms/error'
require 'momentum_cms/fixture'
require 'momentum_cms/fixture/utils'
require 'momentum_cms/fixture/site'
require 'momentum_cms/fixture/page'
require 'momentum_cms/configuration'
require 'momentum_cms/has_settings'
require 'momentum_cms/has_files'
require 'momentum_cms/rails'

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

    # Accessor for the MomentumCms::Configuration object
    # Example use:
    #   MomentumCms.configuration.locale = :en
    def configuration
      @configuration ||= Configuration.new
    end

    alias :config :configuration
  end
end
