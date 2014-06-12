module MomentumCms
  module AncestryUtils
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def ancestor_and_self!(object)
        if object && object.is_a?(self)
          [object.ancestors.to_a, object].flatten.compact
        else
          []
        end
      end

      def ancestry_select(require_root = true, set = nil, path = nil)
        momentum_cms_object_tree = if set.nil?
                                          self.all
                                        else
                                          set
                                        end
        select = []
        momentum_cms_object_tree.each do |momentum_cms_object|
          next if require_root && !momentum_cms_object.is_root?
          select << { id: momentum_cms_object.id, label: "#{path} #{momentum_cms_object.label}" }
          select << self.ancestry_select(false, momentum_cms_object.children, "#{path}-")
        end
        select.flatten!
        select.collect! { |x| [x[:label], x[:id]] } if require_root
        select
      end
    end
  end
end