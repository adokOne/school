module B1Admin
  module Geo
    module Continent
      class ListSerializer < ::B1Admin::BaseSerializer
        attributes :name, :id
      end
    end
  end
end
