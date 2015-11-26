module B1Admin
  module Products
    class ProductsController < B1Admin::ApplicationController


      def allowed_params
        params.require(:item).permit(:active,:name,:title,:desc)
      end

      # Set data for CRUD module
      @model            = ::Product
      # Include CRUD module
      include B1Admin::Concerns::Crud
    end
  end
end
