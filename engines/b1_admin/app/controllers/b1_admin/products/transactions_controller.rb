module B1Admin
  module Products
    class TransactionsController < B1Admin::ApplicationController

      ##
      # Filter items by conditions
      # @return [ActiveRecord::Relation<City>]
      ##
      def filter items,k,v
        items = items.where(product_id: v)       if "product_id" == k
        items = items.where(email: v.to_s)  if "email" == k
        return items
      end

      def allowed_params
        params.require(:item).permit(:product_id,:name,:email,:phone)
      end

      def set_data
        @courses  = ::Product.map{|c| {name: c.name,id: c.id} }
      end

      # Set data for CRUD module
      @model            = ::Transaction
      # Include CRUD module
      include B1Admin::Concerns::Crud
    end
  end
end
