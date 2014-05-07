require_relative 'has_files/base'

module MomentumCms
  ActiveRecord::Base.class_eval do
    def self.has_files(*args, &block)

      include HasFiles::Base
    end
  end
end