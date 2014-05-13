require 'action_view'

module MomentumCms
  module Tags
    module CmsLiquidUtils
      include ActionView::Context
      include ActionView::Helpers::AssetTagHelper

      def initialize(tag_name, params, tokens)
        super
        @params = sanatize_params(params)
        @params = parse_params(@params)
      end

      def sanatize_params(params)
        params.strip
      end

      def parse_params(params)
        result = {}
        params.split(' ').each do |param|
          param = param.split(':')
          result[param[0].to_sym] = param[1]
        end
        result
      end

      def context_get(context, key, default = nil)
        context.environments.first[key]
      rescue
        default
      end

      def print_error_message(exception, tag, context, params)
        if Rails.env.development?
          "<!--\nAn exception occurred with the #{tag.class.name} tag\n\n\nException: #{exception.to_s}\n\n\nContext: #{context.to_yaml}\n\n\nParams: #{@params.to_yaml}\n\n\nStacktrace: #{exception.to_yaml} -->"
        else
          ''
        end
      end
    end
  end
end