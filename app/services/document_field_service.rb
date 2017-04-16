class DocumentFieldService

  attr_accessor :blue_print_ancestors
  attr_accessor :blue_print

  def initialize(blue_print)
    @blue_print = blue_print
    @blue_print_ancestors = MomentumCms::BluePrint.ancestor_and_self!(blue_print)
  end

  def get_fields(list = self.blue_print_ancestors.dup)
    fields = []
    list.each do |blue_print|
      fields << blue_print.field_templates.to_a
    end
    fields.flatten.compact
  end
end