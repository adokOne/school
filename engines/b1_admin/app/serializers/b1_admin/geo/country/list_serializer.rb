module B1Admin
  module Geo
    module Country
      class ListSerializer < ::B1Admin::BaseSerializer
        attributes :code, :old_code,:name, :id, :continent,:meta_is_generated

        def continent
          self.object.continent.nil? ? "" : self.object.continent.name
        end
      end
    end
  end
end
