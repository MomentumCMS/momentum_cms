module MomentumCms
  module Tags
    module CmsLiquidUtils

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
    end
  end
end