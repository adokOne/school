module B1Admin
  module Content
    module Feedback
      class ListSerializer < ::ActiveModel::Serializer
        attributes :name, :id, :phone, :email, :message, :processed, :admin_name
      end
    end
  end
end
