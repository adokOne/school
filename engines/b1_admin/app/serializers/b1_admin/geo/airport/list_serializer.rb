module B1Admin
  module Geo
    module Airport
      class ListSerializer < ::ActiveModel::Serializer
        attributes :name,:id,:country,:city,:show_on_search,:code

        def country
          self.object.country.name
        end

        def city
          self.object.city.name
        end
      end
    end
  end
end