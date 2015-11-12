module B1Admin
  module Content
    module Hotel
      class ItemSerializer < ::B1Admin::BaseSerializer
        attributes :id, :name, :address, :address_translations, :name_translations, :registration_time_in, :registration_time_in_to, :registration_time_out, :registration_time_out_to
        attributes :internet, :internet_type, :internet_place, :internet_price, :breakfast, :breakfast_price

        attributes :parking, :parking_type, :parking_place, :parking_prebook, :parking_price, :country, :city
        attributes :latitude, :longitude, :children_free_age, :children_pay_age, :children_pay_age_cost

        attributes :pets, :pets_pay, :depot_id, :city_id, :country_id, :stars, :status, :base_currency
        attributes :moderate, :children_free_age_bool, :children_pay_age_bool, :certs, :type_id, :owner, :total_rooms, :descriptions

        attributes :features, :zip, :manager, :build_date, :rebuild_date, :languages
        attributes :network

        def manager_attributes
          self.object.manager.to_json
        end

        def address_translations
         if self.object.attributes['address'].kind_of?(String)
          I18n.available_locales.inject({}) do |hash,l|
            hash.merge!({ l => self.object.attributes['address'] })
          end
         else
          self.object.attributes['address']
         end
        end

        def country
          {
            name: self.object.country.try(:name),
            id: self.object.country.try(:id)
          }
        end

        def network
          {
              id: self.object.network.try(:id).try(:to_s),
              name: self.object.network.try(:name)
          }
        end

        def city
          {
            name: self.object.city.try(:name),
            id: self.object.city.try(:id)
          }
        end

        def features
          self.object.feature_ids.inject({}){|hash,item| hash.merge!({item.to_s.to_sym => true})}
        end

        def languages
          self.object.language_staff_ids.inject({}){|hash,item| hash.merge!({item.to_s.to_sym => true})}
        end

        %w(city_id country_id type_id depot_id).each do |meth|
          define_method meth do
            self.object.send(meth).to_s
          end
        end

        def descriptions
          _descriptions = self.object.descriptions.inject({}){ |hash,d|  hash.merge!({ d.depot_id.to_s => B1Admin::Content::Hotel::DesriptionSerializer.new(d) })   }
          Depot.all.each do |provider|
            unless _descriptions.key?(provider._id.to_s)
              if @id
                desc = ::Hotel::Description.create(depot_id: provider._id, hotel_id: self.object._id)
                desc = B1Admin::Content::Hotel::DesriptionSerializer.new(desc)
              else
                desc = ::Hotel::Description.new(depot_id: provider._id,:_id => false)
                desc = B1Admin::Content::Hotel::DesriptionSerializer.new(desc)
              end
              #raise desc.inspect

              _descriptions.merge!({ provider._id.to_s => desc })
            end

          end
          _descriptions
        end

      end
    end
  end
end
