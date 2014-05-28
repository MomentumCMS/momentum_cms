class MomentumCms::Api::Admin::TemplatesController < MomentumCms::Api::Admin::BaseController


  def index
    @templates = MomentumCms::Template.all
    render json: @templates
  end

  def create
    @template = MomentumCms::Template.new(template_params)
    @template.save!
    render json: @template
  rescue ActiveRecord::RecordInvalid
    render json: {errors: @template.errors, status: 422}, status: 422
  end

private

  def template_params
    params.fetch(:template, {}).permit(:label,
                                       :identifier,
                                        :css,
                                        :js,
                                        :value,
                                        :admin_value,
                                        :site_id,
                                        :permanent_record)
  end

end