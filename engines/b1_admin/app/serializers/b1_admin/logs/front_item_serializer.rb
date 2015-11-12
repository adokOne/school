module B1Admin
  module Logs
    class FrontItemSerializer < ::B1Admin::BaseSerializer
      attributes :id, :log_system, :description, :session_id

      def description
        self.object.try(:description).try(:decode_body)
      end

      def id
        self.object._id.to_s
      end
    end
  end
end
