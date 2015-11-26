module B1Admin
  module Products
    module Page
      class ItemSerializer < ::B1Admin::BaseSerializer
        attributes :anons,:desc,:title,:id,:active,:seo_name,:category_id, :logo_file_name, :logo
      end
    end
  end
end
