class MomentumCms::Admin::PagesController < MomentumCms::Admin::BaseController
  before_action :load_momentum_cms_page, only: [:edit, :update, :destroy, :publish, :unpublish]
  before_action :build_momentum_cms_page, only: [:new, :create]
  before_action :load_parent_pages, only: [:edit, :new, :update, :create]

  def index
    @momentum_cms_pages = @current_momentum_cms_site.pages.all
    respond_to do |format|
      format.html
      format.js { render js: @momentum_cms_pages.to_json }
    end
  end

  def unpublish
    @momentum_cms_page.unpublish!
    flash[:success] = 'Page was successfully unpublished.'
    redirect_to edit_cms_admin_site_page_path(@current_momentum_cms_site, @momentum_cms_page)
  end

  def publish
    @momentum_cms_page.publish!
    flash[:success] = 'Page was successfully published.'
    redirect_to edit_cms_admin_site_page_path(@current_momentum_cms_site, @momentum_cms_page)
  end

  def new
  end

  def edit
    build_momentum_cms_blocks(@momentum_cms_page.template, @momentum_cms_page)
  end

  def create
    @momentum_cms_page.save!
    flash[:success] = 'Page was successfully created.'
    redirect_to edit_cms_admin_site_page_path(@current_momentum_cms_site, @momentum_cms_page)
  rescue ActiveRecord::RecordInvalid
    build_momentum_cms_blocks(@momentum_cms_page.template, @momentum_cms_page)
    render action: :new
  end

  def update
    @momentum_cms_page.update_attributes!(momentum_cms_page_params)
    flash[:success] = 'Page was successfully updated.'
    redirect_to action: :edit, id: @momentum_cms_page
  rescue ActiveRecord::RecordInvalid
    build_momentum_cms_blocks(@momentum_cms_page.template, @momentum_cms_page)
    render action: :edit
  end

  def destroy
    @momentum_cms_page.destroy
    flash[:success] = 'Page was successfully destroyed.'
    redirect_to action: :index
  end

  def blocks
    @momentum_cms_page = MomentumCms::Page.where(id: params[:page_id]).first_or_initialize
    @momentum_cms_template = MomentumCms::Template.find(params[:template_id])
    build_momentum_cms_blocks(@momentum_cms_template, @momentum_cms_page)
    render 'momentum_cms/admin/pages/blocks', layout: false
  rescue ActiveRecord::RecordNotFound
    render nothing: true
  end

  private

  def load_parent_pages
    @momentum_cms_parent_pages = @current_momentum_cms_site.pages
    if @momentum_cms_page.persisted?
      @momentum_cms_parent_pages = @momentum_cms_parent_pages.where.not(id: @momentum_cms_page.subtree_ids)
    end
    @momentum_cms_parent_pages
  end

  def load_momentum_cms_page
    @momentum_cms_page = MomentumCms::Page.find(params[:id])
    @momentum_cms_page_revisions = @momentum_cms_page.revisions
    revision_number = params.fetch(:revision, nil)
    if revision_number
      revision = @momentum_cms_page_revisions.where(revision_number: revision_number).first
      if revision
        @momentum_cms_page_revision_data = revision.revision_data
      end
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to action: :index
  end

  def build_momentum_cms_page
    @momentum_cms_page = MomentumCms::Page.new(momentum_cms_page_params)
    @momentum_cms_page.site = @current_momentum_cms_site
  end

  def momentum_cms_page_params
    params.fetch(:momentum_cms_page, {}).permit!
  end

  def build_momentum_cms_blocks(template, page)
    return unless template && page
    block_templates = TemplateBlockService.new(template).get_blocks
    @block_templates_identifiers = block_templates.collect(&:to_identifier)

    if @momentum_cms_page_revision_data
      # Get the current page's existing saved blocks
      momentum_cms_blocks = page.blocks.draft_blocks

      block_revisions = @momentum_cms_page_revision_data[:blocks]
      block_translation_revisions = @momentum_cms_page_revision_data[:blocks_translations]

      momentum_cms_blocks.each do |block|
        block_revision = block_revisions.detect do |x|
          x['identifier'] == block.identifier
        end

        if block_revision
          translation_for_block = block_translation_revisions.find do |x|
            x['momentum_cms_block_id'] == block_revision['id'] && x['locale'] == I18n.locale.to_s
          end

          if translation_for_block
            block.value = translation_for_block['value']
            block.save
          else
            block.translations.where(locale: I18n.locale).destroy_all
          end
        else
          block.destroy
        end
      end

      momentum_cms_blocks = page.blocks.draft_blocks.reload
      block_revisions.each do |block_revision|
        block = momentum_cms_blocks.where(block_template: block_revision['block_template_id'],
                                          identifier: block_revision['identifier']).first_or_initialize
        if block.new_record?
          block.save
          translation_for_block = block_translation_revisions.find do |x|
            x['momentum_cms_block_id'] == block_revision['id'] && x['locale'] == I18n.locale.to_s
          end
          if translation_for_block
            block.value = translation_for_block['value']
            block.save
          end
        end
      end
    end

    momentum_cms_blocks = page.blocks.draft_blocks
    # Build blocks from each block_templates
    block_templates.each do |block_template|
      block = momentum_cms_blocks.detect { |x| x.identifier == block_template.to_identifier && x.block_type == 'draft' }
      if block.nil?
        page.blocks.build(
          identifier: block_template.to_identifier,
          block_template_id: block_template.id
        )
      end
    end
  end
end
