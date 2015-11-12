module B1Admin
  module Settings
    module Admins
      class ListSerializer < ::ActiveModel::Serializer
        attributes :avatar, :name,:email,:blocked,:phone,:position,:created_at,:blocked_until,:id,:active,:signins_count
      end
    end
  end
end