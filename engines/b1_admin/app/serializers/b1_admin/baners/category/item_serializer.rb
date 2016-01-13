module B1Admin
  module Baners
    module Category
      class ItemSerializer < ::B1Admin::BaseSerializer
        attributes :id,:parent_id,:seo_name,:desc,:title, :logo_file_name, :logo,:meta_is_generated
        attributes *[B1Admin::LANGS.map{|l| ["title_#{l}","desc_#{l}","meta_desc_#{l}","meta_title_#{l}","meta_keys_#{l}", "city_seo_template_#{l}"] } ].flatten
      end
    end
  end
end
