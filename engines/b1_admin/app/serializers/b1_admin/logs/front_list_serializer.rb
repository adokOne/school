module B1Admin
  module Logs
    class FrontListSerializer < ::ActiveModel::Serializer
      attributes :id, :status,:session_id,:time,:action,:log_system

      def id
        self.object._id.to_s
      end

    end
  end
end
