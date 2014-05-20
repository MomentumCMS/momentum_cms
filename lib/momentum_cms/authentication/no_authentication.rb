module MomentumCms
  module Authentication
    module NoAuthentication
      def authenticate
        true
      end
    end
  end
end