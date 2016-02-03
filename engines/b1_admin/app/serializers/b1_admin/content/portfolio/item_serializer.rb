module B1Admin
  module Content
    module Portfolio
      class ItemSerializer < ::B1Admin::BaseSerializer
        attributes :title,:category,:anons, :desc, :site,:id, :photos, :active

        def photos
          []
        end
      end
    end
  end
end
