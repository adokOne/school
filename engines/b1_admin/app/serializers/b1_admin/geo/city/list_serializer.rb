module B1Admin
  module Geo
    module City
      class ListSerializer < ::B1Admin::BaseSerializer
        attributes :name,:id,:code,:show_on_search,:show_as_popular,:continent,:country,:meta_is_generated

        def continent
          self.object.continent.nil? ? "" : self.object.continent.name
        end

        def country
          self.object.country.nil? ? "" : self.object.country.name
        end

      end
    end
  end
end
