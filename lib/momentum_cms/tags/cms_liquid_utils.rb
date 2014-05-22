require 'action_view'
require 'cgi'


module MomentumCms
  module Tags
    module CmsLiquidUtils
      include ActionView::Context
      include ActionView::Helpers::AssetTagHelper
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::FormTagHelper

      PARAMS_REGEXP = Regexp.new(/(?:"((?:\\.|[^"])*)"|([^\s]*)):\s*(?:"((?:\\.|[^"])*)"|([^\s]*))/).freeze

      def initialize(tag_name, params, tokens)
        super
        @params = sanatize_params(params)
        @params = parse_params(@params)
      end

      def sanatize_params(params)
        params.strip
      end

      def parse_params(params)
        if params.is_a?(String)
          Hash[params.scan(PARAMS_REGEXP).map(&:compact).map { |x| x.map { |y| (y || '').gsub(/\\/, '') } }]
        else
          Hash.new()
        end
      end

      def context_get!(context, key, default = nil)
        context_get(context, key, default, true)
      end

      def context_get(context, key, default = nil, raise_on_nil = false)
        value = _context_get(context, key, default)
        if raise_on_nil && value.nil?
          raise CmsTagError.new("#{key} was not passed in the rendering context")
        end
        value
      end

      def _context_get(context, key, default = nil)
        context.environments.first[key]
      rescue
        default
      end

      def params_get!(key, default = nil)
        params_get(key, default, true)
      end

      def params_get(key, default = nil, raise_on_nil = false)
        value = @params.fetch(key, default)

        if raise_on_nil && value.nil?
          raise CmsTagError.new("#{key} was not passed in the tag")
        end

        value
      end

      def print_error_message(exception, tag, context, params, debug = Rails.env.development?)
        if debug
          "<!--\n" + CGI.escapeHTML("An exception occurred with the #{tag.class.name} tag\n\n\nException: #{exception.to_s}\n\n\nContext: #{context.to_yaml}\n\n\nParams: #{params.to_yaml}") + '-->'
        else
          ''
        end
      end
    end
  end
end