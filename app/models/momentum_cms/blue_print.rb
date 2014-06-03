class MomentumCms::BluePrint < ActiveRecord::Base
  # == MomentumCms ==========================================================

  include MomentumCms::BelongsToSite

  self.table_name = 'momentum_cms_blue_prints'

  # == Constants ============================================================
  # == Relationships ========================================================

  has_many :documents,
           dependent: :destroy

  has_many :field_templates,
           dependent: :destroy

  accepts_nested_attributes_for :field_templates

  # == Extensions ===========================================================

  has_ancestry

  translates :label, fallbacks_for_empty_translations: true

  # == Validations ==========================================================

  validates :identifier,
            presence: true

  validates :identifier,
            uniqueness: true

  # == Scopes ===============================================================
  # == Callbacks ============================================================
  # == Class Methods ========================================================

  def self.ancestry_select(require_root = true, set = nil, path = nil)
    momentum_cms_blue_prints_tree = if set.nil?
                                             MomentumCms::BluePrint.all
                                           else
                                             set
                                           end
    select = []
    momentum_cms_blue_prints_tree.each do |momentum_cms_blue_print|
      next if require_root && !momentum_cms_blue_print.is_root?
      select << { id: momentum_cms_blue_print.id, label: "#{path} #{momentum_cms_blue_print.label}" }
      select << MomentumCms::BluePrint.ancestry_select(false, momentum_cms_blue_print.children, "#{path}-")
    end
    select.flatten!
    select.collect! { |x| [x[:label], x[:id]] } if require_root
    select
  end


  def self.ancestor_and_self!(blue_print)
    if blue_print && blue_print.is_a?(MomentumCms::BluePrint)
      [blue_print.ancestors.to_a, blue_print].flatten.compact
    else
      []
    end
  end
  # == Instance Methods =====================================================

end
