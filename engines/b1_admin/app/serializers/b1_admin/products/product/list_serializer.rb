module B1Admin
  module Products
    module Product
      class ListSerializer < ::ActiveModel::Serializer
        attributes :name,:logo,:active,:id
      end
    end
  end
end
