module B1Admin
  module Geo
    module Continent
      class ItemSerializer < ::B1Admin::BaseSerializer
        attributes *[[:id] + B1Admin::LANGS.map{|l| "desc_#{l}"} + B1Admin::LANGS.map{|l| "name_#{l}"}].flatten
      end
    end
  end
end
