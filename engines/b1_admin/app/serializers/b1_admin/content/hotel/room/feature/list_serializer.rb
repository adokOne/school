module B1Admin
  module Content
    module Hotel
      module Room
        module Feature
          class ListSerializer < ::ActiveModel::Serializer
            attributes :name,  :id,  :service

            def service
              self.object.service.try(:name)
            end

          end
        end
      end
    end
  end
end
