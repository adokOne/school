module B1Admin
  module Content
    module Hotel
      module Room
        module Service
          class ListSerializer < ::ActiveModel::Serializer
            attributes :name,  :id, :features

            def features
              self.object.features.map(&:name)
            end
          end
        end
      end
    end
  end
end
