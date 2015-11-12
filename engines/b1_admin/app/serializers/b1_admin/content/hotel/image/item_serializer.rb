module B1Admin
  module Content
    module Hotel
      class ItemSerializer < ::B1Admin::BaseSerializer
        attributes :name_translations, :registration_time_in, :registration_time_in_to, :registration_time_out, :registration_time_out_to
        attributes :internet, :internet_type, :internet_place, :internet_price, :breakfast, :breakfast_price

        attributes :parking, :parking_type, :parking_place, :parking_prebook, :parking_price, :country, :city
        attributes :latitude, :longitude, :children_free_age, :children_pay_age, :children_pay_age_cost

        attributes :pets, :pets_pay, :depot_id, :city_id, :country_id, :stars, :status, :base_currency
        attributes :moderate, :children_free_age_bool, :children_pay_age_bool, :certs, :type_id, :owner, :total_rooms, :descriptions

        def type_id
          self.object.type_id.to_s
        end

        def manager_attributes
          self.object.manager.to_json
        end

        def country
          {
            name: self.object.country.try(:name),
            id: self.object.country.try(:id)
          }
        end

        def city
          {
            name: self.object.city.try(:name),
            id: self.object.city.try(:id)
          }
        end

        def descriptions
          _descriptions = self.object.descriptions.inject({}){ |hash,d|  hash.merge!({ d.depot_id.to_s => B1Admin::Content::Hotel::DesriptionSerializer.new(d) })   }
          Depot.all.each do |provider|
            _descriptions.merge!({ provider._id.to_s => B1Admin::Content::Hotel::DesriptionSerializer.new })  unless _descriptions.key?(provider._id.to_s)
          end
          _descriptions
        end

      end
    end
  end
end
