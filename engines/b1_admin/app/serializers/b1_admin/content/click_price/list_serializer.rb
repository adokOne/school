module B1Admin
  module Content
    module ClickPrice
      class ListSerializer < ::ActiveModel::Serializer
        attributes :title, :id, :active
      end
    end
  end
end
