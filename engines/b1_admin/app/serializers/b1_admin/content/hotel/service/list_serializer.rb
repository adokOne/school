module B1Admin
  module Content
    module Hotel
      module Service
        class ListSerializer < ::ActiveModel::Serializer
          attributes :name,  :id, :key, :features

          def features
            self.object.features.map(&:name)
          end
        end
      end
    end
  end
end
