module B1Admin
  module Content
    module Hotel
      module Room
        module Feature
          class ItemSerializer < ::B1Admin::BaseSerializer
            attributes :name_translations, :id,  :service_id, :show_hotelier

            def service_id
              self.object.service_id.to_s
            end
          end
        end
      end
    end
  end
end
