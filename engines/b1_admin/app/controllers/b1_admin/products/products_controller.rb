module B1Admin
  module Products
    class ProductsController < B1Admin::ApplicationController


      def allowed_params
        params.require(:item).permit(:active,:name,:title,:desc,:show_in_top, :has_sale, :has_second_price, :is_one_time, :price, :second_price, :sale_price, :period)
      end

      # Set data for CRUD module
      @model            = ::Product
      # Include CRUD module
      include B1Admin::Concerns::Crud
    end
  end
end
