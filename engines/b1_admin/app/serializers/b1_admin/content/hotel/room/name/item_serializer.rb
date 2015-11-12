module B1Admin
  module Content
    module Hotel
      module Room
        module Name
          class ItemSerializer < ::B1Admin::BaseSerializer
            attributes :name_translations, :type_id, :id, :show_hotelier

            def type_id
              self.object.type_id.to_s
            end
          end
        end
      end
    end
  end
end
