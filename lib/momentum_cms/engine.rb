require 'jquery-rails'
require 'jquery-ui-rails'
require 'haml-rails'
require 'sass-rails'
require 'ancestry'
require 'globalize'
require 'fileutils'
require 'json'
require 'liquid'
require 'paperclip'
require 'simple_form'
require 'rails-i18n'
require 'active_model_serializers'
require 'tinymce-rails'

module MomentumCms
  class Engine < ::Rails::Engine

    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.assets false
      g.helper false
    end

  end
end
