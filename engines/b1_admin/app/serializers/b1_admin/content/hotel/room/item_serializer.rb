module B1Admin
  module Content
    module Hotel
      module Room
        class ItemSerializer < ::B1Admin::BaseSerializer
          attributes :id, :features, :hotel_id, :total_apartments, :smoking, :count, :quota
          attributes :max_adults_count, :child_bool, :max_child_count, :square, :price, :currency
          attributes :type_id, :name_id
          attributes :hotel_type_id, :description

          def hotel_type_id
            object.hotel.try(:type).try(:id)
          end

          def type_id
            object.type_id.to_s
          end

          def name_id
            object.name_id.to_s
          end

          def features
            self.object.feature_ids.inject({}){|hash,item| hash.merge!({item.to_s.to_sym => true})}
          end

        end
      end
    end
  end
end
