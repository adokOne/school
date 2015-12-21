module B1Admin
  module Products
    class OrdersController < B1Admin::ApplicationController

      def allowed_params
        params.require(:item).permit( :product_id, :id, :product_id, :page_id,  :amount,  :status )
      end

      def set_data
        @products = ::Product.all.map{|item| {name: item.name, id: item.id } }
      end

      def before_update
        user = params.dup[:item].delete("user")
        if user.kind_of?(Hash) && user["originalObject"].present?
          @params_to_update[:user_id] = user["originalObject"]["id"]
        end
        @params_to_update[:admin_id] = current_admin.id
      end

      # Set data for CRUD module
      @model = ::Order
      # Include CRUD module
      include B1Admin::Concerns::Crud
    end
  end
end
