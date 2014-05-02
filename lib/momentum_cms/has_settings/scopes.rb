module MomentumCms
  module HasSettings
    module Scopes
      def with_settings
        joins("INNER JOIN momentum_cms_settings ON #{settings_join_condition}").
          uniq
      end

      def with_settings_for(var)
        raise ArgumentError.new('Symbol expected!') unless var.is_a?(Symbol)
        joins("INNER JOIN momentum_cms_settings ON #{settings_join_condition} AND momentum_cms_settings.var = '#{var}'")
      end

      def without_settings
        joins("LEFT JOIN momentum_cms_settings ON #{settings_join_condition}").
          where('momentum_cms_settings.id IS NULL')
      end

      def without_settings_for(var)
        raise ArgumentError.new('Symbol expected!') unless var.is_a?(Symbol)
        joins("LEFT JOIN momentum_cms_settings ON  #{settings_join_condition} AND momentum_cms_settings.var = '#{var}'").
          where('momentum_cms_settings.id IS NULL')
      end

      def settings_join_condition
        "momentum_cms_settings.target_id   = #{table_name}.#{primary_key} AND
       momentum_cms_settings.target_type = '#{base_class.name}'"
      end
    end
  end
end