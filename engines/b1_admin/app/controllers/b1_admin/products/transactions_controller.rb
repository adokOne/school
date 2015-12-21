module B1Admin
  module Products
    class TransactionsController < B1Admin::ApplicationController

      ##
      # Filter items by conditions
      # @return [ActiveRecord::Relation<City>]
      ##
      def filter items,k,v
        items = items.where(status: v.to_i)       if "status" == k
        if "email" == k
          if user = ::User.find_by_email(v)
            items = items.where(user_id: user.id)
          end
        end

        return items
      end

      def before_update
        user = params.dup[:item].delete("user")
        if user.kind_of?(Hash) && user["originalObject"].present?
          @params_to_update[:user_id] = user["originalObject"]["id"]
        end
      end

      def allowed_params
        params.require(:item).permit(:product_id,:description,:amount,:status)
      end

      def set_data
        @courses  = ::Product.all.map{|c| {name: c.name,id: c.id} }
      end

      # Set data for CRUD module
      @model            = ::Transaction
      @order            = [{id: :desc}]
      # Include CRUD module
      include B1Admin::Concerns::Crud
    end
  end
end
