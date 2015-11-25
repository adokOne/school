module B1Admin
  module Geo
    module Airport
      class ItemSerializer < ::ActiveModel::Serializer
        attributes :name,:id,:country_id,:city_id,:show_on_search,:code,:time_zone
      end
    end
  end
end
