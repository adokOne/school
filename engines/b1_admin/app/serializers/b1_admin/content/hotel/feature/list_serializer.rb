module B1Admin
  module Content
    module Hotel
      module Feature
        class ListSerializer < ::ActiveModel::Serializer
          attributes :name,  :id, :logo, :service

          def service
            self.object.service.try(:name)
          end

        end
      end
    end
  end
end
