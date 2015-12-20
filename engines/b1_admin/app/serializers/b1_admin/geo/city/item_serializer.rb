module B1Admin
  module Geo
    module City
      class ItemSerializer < ::B1Admin::BaseSerializer
        attributes :name, :id, :continent_id,:country_id,:code,:show_on_search,:show_as_popular,:logo_file_name,:time_zone,:meta_is_generated
        attributes *[B1Admin::LANGS.map{|l| ["anons_#{l}","name_#{l}","desc_#{l}","meta_desc_#{l}","meta_title_#{l}","meta_keys_#{l}","anons_#{l}"] } ].flatten

      end
    end
  end
end
