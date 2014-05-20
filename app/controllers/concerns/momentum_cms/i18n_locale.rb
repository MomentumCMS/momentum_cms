module MomentumCms
  module I18nLocale
    extend ActiveSupport::Concern

    included do
      before_action :set_locale

      def set_locale
        if params[:locale]
          session[:locale] = params[:locale]
        end
        I18n.locale = session[:locale] || params[:locale] || :en
      end
    end

    module ClassMethods
    end
  end
end