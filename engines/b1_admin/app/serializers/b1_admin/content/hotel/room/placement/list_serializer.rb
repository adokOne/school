module B1Admin::Content::Hotel::Room::Placement
  class ListSerializer < ::ActiveModel::Serializer
    attributes :id, :name, :name_id, :tariffs, :allowed_tariff_types, :hotelier_id, :room_id
    attributes :adults_count

    private
    def name_id
      object.name.try(:id).try(:to_s)
    end

    def name
      object.name.try(:name)
    end

    def room_id
      object.room_id.to_s
    end

    def hotelier_id
      object.hotelier.try(:_id).try(:to_s)
    end

    def id
      object.id.to_s
    end

    def allowed_tariff_types
      exists_tariff_types = object.tariffs.map{|t| t.tarif_type}
      ::Hotel::Room::Place::Tarif::TYPES.reject do |t|
        exists_tariff_types.include?(t)
      end.map do |t|
        {
            id: t,
            name: I18n.t("b1_admin.tariff.#{t}")
        }
      end
    end

    def tariffs
      ActiveModel::ArraySerializer.new(
          object.tariffs,
          each_serializer: Tariff::ListSerializer
      )
    end
  end
end
