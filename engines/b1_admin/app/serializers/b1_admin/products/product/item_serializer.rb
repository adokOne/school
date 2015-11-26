module B1Admin
  module Products
    module Product
      class ItemSerializer < ::B1Admin::BaseSerializer
        attributes :name, :active, :logo_file_name,:id, :title, :desc, :show_in_top, :has_sale, :has_second_price, :is_one_time, :price, :second_price, :sale_price, :logo, :period
      end
    end
  end
end
