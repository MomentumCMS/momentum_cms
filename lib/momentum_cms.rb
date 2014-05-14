require 'jquery-rails'
require 'jquery-ui-rails'
require 'haml-rails'
require 'sass-rails'
require 'ancestry'
require 'globalize'
require 'paper_trail'
require 'globalize-versioning'
require 'fileutils'
require 'json'
require 'liquid'
require 'paperclip'
require 'simple_form'

require 'momentum_cms/engine'
require 'momentum_cms/error'

require 'momentum_cms/authentication/http_authentication'
require 'momentum_cms/authentication/no_authentication'


require 'momentum_cms/tags/cms_liquid_utils'
require 'momentum_cms/tags/cms_base_block'
require 'momentum_cms/tags/cms_base_tag'
require 'momentum_cms/tags/cms_fixture'
require 'momentum_cms/tags/cms_yield'
require 'momentum_cms/tags/cms_block'
require 'momentum_cms/tags/cms_menu'
require 'momentum_cms/tags/cms_html_meta'
require 'momentum_cms/tags/cms_file'
require 'momentum_cms/tags/cms_snippet'
require 'momentum_cms/tags/cms_breadcrumb'
require 'momentum_cms/tags/cms_blank'


require 'momentum_cms/fixture'
require 'momentum_cms/fixture/base'
require 'momentum_cms/fixture/utils'
require 'momentum_cms/fixture/template'
require 'momentum_cms/fixture/snippet'
require 'momentum_cms/fixture/site'
require 'momentum_cms/fixture/page'
require 'momentum_cms/fixture/file'
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
