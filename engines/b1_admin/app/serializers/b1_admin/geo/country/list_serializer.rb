module B1Admin
  module Geo
    module Country
      class ListSerializer < ::B1Admin::BaseSerializer
        attributes :name, :id

        def continent
          self.object.continent.nil? ? "" : self.object.continent.name
        end
      end
    end
  end
end
