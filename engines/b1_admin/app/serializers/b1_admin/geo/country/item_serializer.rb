module B1Admin
  module Geo
    module Country
      class ItemSerializer < ::B1Admin::BaseSerializer
        attributes :name, :id
        attributes *[B1Admin::LANGS.map{|l| ["name_#{l}"] } ].flatten
      end
    end
  end
end
