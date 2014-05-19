class MomentumCms::Admin::ContentsController < MomentumCms::Admin::BaseController
  before_action :load_moment_cms_page
  before_action :load_moment_cms_content, only: [:edit, :update, :destroy]
  before_action :build_moment_cms_content, only: [:new, :create]

  def index
    @momentum_cms_contents = @momentum_cms_page.contents.all
  end

  def new
  end

  def edit
    @momentum_cms_template = @momentum_cms_page.template
    @template_array = MomentumCms::Template.ancestor_and_self!(@momentum_cms_template)
    @content = nil
    @template_array.reverse.each do |template|
      liquid = Liquid::Template.parse(template.admin_value)
      @content = liquid.render(yield: @content,
                               view_context: :admin,
                               cms_template: template,
                               cms_site: @current_momentum_cms_site,
                               cms_page: @momentum_cms_page,
                               cms_content: @momentum_cms_content)
    end

    # Get the current Content's existing saved blocks
    @content_blocks = @momentum_cms_content.blocks.to_a

    # Get all the block templates that is assigned to the template
    @block_templates = TemplateBlockService.new(@momentum_cms_template).get_blocks

    # Build blocks from each block_templates
    @block_templates.each do |block_template|
      if @content_blocks.detect { |x| x.identifier == "#{block_template.template.identifier}::#{block_template.identifier}" }.nil?
        @momentum_cms_content.blocks.build(
          identifier: "#{block_template.template.identifier}::#{block_template.identifier}",
          block_template_id: block_template.id
        )
      end
    end
  end

  def create
    @momentum_cms_content.save!
    flash[:success] = 'Content was successfully created.'
    redirect_to action: :edit, :id => @momentum_cms_content
  rescue ActiveRecord::RecordInvalid
    render action: :new
  end

  def update
    @momentum_cms_content.update_attributes!(momentum_cms_content_params)
    flash[:success] = 'Content was successfully updated.'
    redirect_to action: :edit, :id => @momentum_cms_content
  rescue ActiveRecord::RecordInvalid
    render action: :edit
  end

  def destroy
    @momentum_cms_content.destroy
    flash[:success] = 'Content was successfully destroyed.'
    redirect_to action: :index
  end

  private
  def load_moment_cms_page
    @momentum_cms_page = MomentumCms::Page.find(params[:page_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to action: :index
  end

  def load_moment_cms_content
    @momentum_cms_content = MomentumCms::Content.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to action: :index
  end

  def build_moment_cms_content
    @momentum_cms_content = MomentumCms::Content.new(momentum_cms_content_params)
    @momentum_cms_content.page = @momentum_cms_page
  end

  def momentum_cms_content_params
    params.fetch(:momentum_cms_content, {}).permit!
  end
end
