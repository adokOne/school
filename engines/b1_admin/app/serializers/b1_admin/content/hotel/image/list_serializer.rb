module B1Admin
  module Content
    module Hotel
      module Image

        class ListSerializer < ::ActiveModel::Serializer
          attributes :id, :hotel_id, :image_url, :main_image, :description_translations

          def hotel_id
            self.object.hotel_id.to_s
          end
        end

      end
    end
  end
end
