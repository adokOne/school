module B1Admin
  module Content
    module Feedback
      class ListSerializer < ::ActiveModel::Serializer
        attributes :name, :id, :phone, :email
      end
    end
  end
end
