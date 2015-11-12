module B1Admin
  module Content
    module Hotel
      module Type
        class ListSerializer < ::ActiveModel::Serializer
          attributes :name, :description, :id
        end
      end
    end
  end
end
