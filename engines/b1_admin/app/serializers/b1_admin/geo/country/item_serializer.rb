module B1Admin
  module Geo
    module Country
      class ItemSerializer < ::B1Admin::BaseSerializer
        attributes :code, :old_code,:name, :id, :continent_id,:flag_file_name,:g_map_url,:meta_is_generated
        attributes *[B1Admin::LANGS.map{|l| ["name_#{l}","desc_#{l}","meta_desc_#{l}","meta_title_#{l}","meta_keys_#{l}"] } ].flatten
      end
    end
  end
end
