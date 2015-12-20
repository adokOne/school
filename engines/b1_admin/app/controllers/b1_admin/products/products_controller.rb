module B1Admin
  module Products
    class ProductsController < B1Admin::ApplicationController


      def allowed_params
        translated_fields = I18n.available_locales.map do |l|
          ["desc_#{l}","name_#{l}","anons_#{l}"]
        end
        params.require(:item).permit( translated_fields + [:active,:name,:title,:desc,:show_in_top, :has_sale, :has_second_price, :is_one_time, :price, :second_price, :sale_price, :period])
      end


      # Set data for CRUD module
      @model            = ::Product
      # Include CRUD module
      include B1Admin::Concerns::Crud
    end
  end
end
