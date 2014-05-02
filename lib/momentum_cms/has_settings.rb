require_relative 'has_settings/configuration'
require_relative 'has_settings/base'
require_relative 'has_settings/scopes'

module MomentumCms
  
  
  
  
  ActiveRecord::Base.class_eval do
    def self.has_settings(*args, &block)
      HasSettings::Configuration.new(*args.unshift(self), &block)

      include HasSettings::Base
      extend HasSettings::Scopes
    end
  end
end