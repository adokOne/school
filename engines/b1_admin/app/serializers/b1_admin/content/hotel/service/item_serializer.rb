module B1Admin
  module Content
    module Hotel
      module Service
        class ItemSerializer < ::B1Admin::BaseSerializer
          attributes :name_translations, :description_translations, :id, :key, :show_hotelier
        end
      end
    end
  end
end
