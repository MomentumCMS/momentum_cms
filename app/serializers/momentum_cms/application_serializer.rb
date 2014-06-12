class MomentumCms::ApplicationSerializer < ActiveModel::Serializer
  attributes :current_locale

  def current_locale
    I18n.locale
  end
end