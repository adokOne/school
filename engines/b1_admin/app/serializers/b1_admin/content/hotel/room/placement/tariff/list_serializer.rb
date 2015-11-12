module B1Admin::Content::Hotel::Room::Placement::Tariff
  class ListSerializer < ::ActiveModel::Serializer
    attributes :id, :name, :diapasons, :hotelier_id, :price, :currency, :placement_id, :tarif_type, :breakfast
    attributes :canceled_date_count,
               :canceled_nights_count,
               :canceled_price,
               :canceled_currency
    attributes :room_id

    private

    def room_id
      object.placement.room.id.to_s
    end

    def hotelier_id
      self.object.hotelier.try(:_id).try(:to_s)
    end

    def id
      object._id.to_s
    end

    def placement_id
      object.placement_id.to_s
    end

    def price
      '%.2f' % object.price.to_f
    end

    def one_day_canceled
      '%.2f' % object.one_day_canceled
    end

    def two_days_canceled
      '%.2f' % object.two_days_canceled
    end

    def one_week_canceled
      '%.2f' % object.one_week_canceled
    end


    def diapasons
      _diapasons = []
      object.diapasons.map do |diapason|
        diapason.date_range.each do |day|
          _diapasons << {
              day:   day.strftime('%Y-%m-%d'),
              price: '%.2f' % diapason.price.to_f,
              currency: diapason.currency,
              # quota_not_eq_room_quota: diapason.quota != object.placement.room.quota
          }
        end
      end
      _diapasons
    end

    def name
      I18n.t("b1_admin.tariff.#{object.tarif_type}")
    end
  end
end
