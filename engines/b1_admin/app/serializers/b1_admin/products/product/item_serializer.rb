module B1Admin
  module Products
    module Product
      class ItemSerializer < ::B1Admin::BaseSerializer
        attributes  :show_on_landing,:show_in_cabinet,:active, :logo_file_name,:id, :title,  :show_in_top, :has_sale, :has_second_price, :is_one_time, :price, :second_price, :sale_price, :logo, :period
        attributes  :has_vip_status, :has_category_top, :has_region_top, :has_main_top, :has_adwords_stat, :period_of_service
        attributes *[B1Admin::LANGS.map{|l| ["name_#{l}","desc_#{l}","anons_#{l}"] } ].flatten
      end
    end
  end
end

