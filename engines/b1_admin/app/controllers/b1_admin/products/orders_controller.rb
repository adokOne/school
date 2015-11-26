module B1Admin
  module Products
    class OrdersController < B1Admin::ApplicationController

      def allowed_params
        params.require(:item).permit( :product_id, :id )
      end


      # Set data for CRUD module
      @model = ::Order
      # Include CRUD module
      include B1Admin::Concerns::Crud
    end
  end
end
