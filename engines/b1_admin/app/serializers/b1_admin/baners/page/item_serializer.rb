module B1Admin
  module Baners
    module Page
      class ItemSerializer < ::B1Admin::BaseSerializer
        attributes :anons,:desc,:title,:id,:active,:seo_name,:category_id, :logo_file_name, :logo, :city_id
      end
    end
  end
end
