module B1Admin
  module Content
    module Hotel
      module Type
        class ItemSerializer < ::B1Admin::BaseSerializer
          attributes :name_translations, :description_translations, :id
        end
      end
    end
  end
end
