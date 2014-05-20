class MenuBuilderService

  attr_accessor :json
  attr_accessor :menu_items
  attr_accessor :existing_menu_items

  def initialize(options = {})
    @menu = options.fetch(:menu, nil)
    raise ArgumentError.new(':menu must be passed in as an MomentumCms::Menu object') unless @menu.is_a?(MomentumCms::Menu)

    @json = options.fetch(:json, nil)
    @menu_items = []
    @existing_menu_items = @menu.menu_items.to_a
  end

  def find_or_initialize_menu_item(page_id, parent)
    new_menu_item = MomentumCms::MenuItem.new(
      menu: @menu,
      linkable: MomentumCms::Page.where(id: page_id).first
    )
    menu_item = @existing_menu_items.find do |existing_menu_item|
      existing_menu_item.linkable_id == page_id
    end
    menu_item = new_menu_item if menu_item.nil?
    menu_item.parent = parent
    menu_item
  end

  def create_or_update!(json=self.json, parent = nil)
    json.each do |item|
      id = item['id']
      children = item['children']
      menu_item = find_or_initialize_menu_item(id, parent)
      menu_item.save!
      @menu_items << menu_item
      if children
        create_or_update!(children, menu_item)
      end
    end

    MomentumCms::MenuItem.for_menu(@menu).where.not(id: @menu_items.collect(&:id)).destroy_all if parent.nil?
  end
end
