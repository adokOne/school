module B1Admin
  module Content
    module Hotel
      class DesriptionSerializer < ::B1Admin::BaseSerializer

        attributes :_id,:id,:short_description_translations,:full_description_translations, :location_translations, :children_translations, :depot_id
        attributes :pets_description_translations, :groups_translations, :taxes_translations, :policy_translations

        def depot_id
          self.object.depot_id.to_s
        end

        def _id
          self.object._id.to_s
        end

      end
    end
  end
end
