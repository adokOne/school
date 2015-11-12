module B1Admin
  module Content
    module Hotel
      module Room
        module Name
          class ListSerializer < ::ActiveModel::Serializer
            attributes :name, :type, :id

            def type
              self.object.type.try(:name)
            end
          end
        end
      end
    end
  end
end
