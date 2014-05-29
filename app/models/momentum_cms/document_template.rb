class MomentumCms::DocumentTemplate < ActiveRecord::Base
  # == MomentumCms ==========================================================

  include MomentumCms::BelongsToSite

  self.table_name = 'momentum_cms_document_templates'

  # == Constants ============================================================
  # == Relationships ========================================================

  has_many :documents,
           dependent: :destroy

  has_many :field_templates,
           dependent: :destroy

  accepts_nested_attributes_for :field_templates

  # == Extensions ===========================================================

  has_ancestry

  has_paper_trail

  translates :label, fallbacks_for_empty_translations: true, versioning: :paper_trail

  # == Validations ==========================================================

  validates :identifier,
            presence: true

  validates :identifier,
            uniqueness: true

  # == Scopes ===============================================================
  # == Callbacks ============================================================
  # == Class Methods ========================================================

  def self.ancestry_select(require_root = true, set = nil, path = nil)
    momentum_cms_document_templates_tree = if set.nil?
                                             MomentumCms::DocumentTemplate.all
                                           else
                                             set
                                           end
    select = []
    momentum_cms_document_templates_tree.each do |momentum_cms_document_template|
      next if require_root && !momentum_cms_document_template.is_root?
      select << { id: momentum_cms_document_template.id, label: "#{path} #{momentum_cms_document_template.label}" }
      select << MomentumCms::DocumentTemplate.ancestry_select(false, momentum_cms_document_template.children, "#{path}-")
    end
    select.flatten!
    select.collect! { |x| [x[:label], x[:id]] } if require_root
    select
  end


  def self.ancestor_and_self!(document_template)
    if document_template && document_template.is_a?(MomentumCms::DocumentTemplate)
      [document_template.ancestors.to_a, document_template].flatten.compact
    else
      []
    end
  end
  # == Instance Methods =====================================================

end
