module B1Admin
  module Content
    module Hotel
      module Room

        class ListSerializer < ::ActiveModel::Serializer
          attributes :id, :hotel, :type, :count, :quota, :logo, :max_adults_count
          attributes :max_child_count, :square, :price, :currency, :name
          attributes :hotelier_id, :placements
          attributes :quotas

          def quotas
            _diapasons = []
            object.quotas.map do |diapason|
              diapason.date_range.each do |day|
                _diapasons << {
                    day:   day.strftime('%Y-%m-%d'),
                    quota: diapason.quota
                }
              end
            end
            _diapasons
          end

          def hotel
            self.object.hotel.try(:name)
          end

          def hotelier_id
            self.object.hotelier.try(:_id).try(:to_s)
          end

          def type
            self.object.type.try(:name)
          end

          def name
            self.object.name.try(:name)
          end

          def id
            self.object._id.to_s
          end

          def placements
            ActiveModel::ArraySerializer.new(
                object.try(:placements),
                each_serializer:  Placement::ListSerializer
            )
          end
        end

      end
    end
  end
end
