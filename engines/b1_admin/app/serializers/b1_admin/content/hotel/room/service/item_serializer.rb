module B1Admin
  module Content
    module Hotel
      module Room
        module Service
          class ItemSerializer < ::B1Admin::BaseSerializer
            attributes :name_translations, :id, :show_hotelier
          end
        end
      end
    end
  end
end
