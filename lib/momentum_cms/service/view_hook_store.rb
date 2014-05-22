module MomentumCms
  module Service
    module ViewHookStore
      def self.view_hooks
        @@view_hooks ||= {}
      end

      def self.register_view_hook(name)
        self.view_hooks[name] ||= MomentumCms::ViewHook.new
      end

      def self.get_view_hook(name)
        self.view_hooks[name]
      end
    end
  end
end