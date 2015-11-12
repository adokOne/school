module B1Admin
  module Content
    module Hotel
      module Room
        module Type
          class ListSerializer < ::ActiveModel::Serializer
            attributes :name, :id, :max_peoples
          end
        end
      end
    end
  end
end
