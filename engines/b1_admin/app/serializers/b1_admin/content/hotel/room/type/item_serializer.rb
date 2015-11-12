module B1Admin
  module Content
    module Hotel
      module Room
        module Type
          class ItemSerializer < ::B1Admin::BaseSerializer
            attributes :name_translations, :max_peoples, :show_hotelier, :id
          end
        end
      end
    end
  end
end
