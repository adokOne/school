module B1Admin
  module Content
    module Hotel
      module Feature
        class ItemSerializer < ::B1Admin::BaseSerializer
          attributes :name_translations, :id, :logo_file_name, :service_id, :show_hotelier

          def service_id
            self.object.service_id.to_s
          end
        end
      end
    end
  end
end
