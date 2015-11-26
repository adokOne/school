module B1Admin
  module Baners
    class UsersController < B1Admin::ApplicationController

      ##
      # Filter items by conditions
      # @return [ActiveRecord::Relation<City>]
      ##
      def filter items,k,v
        items = items.where(email: v.to_s)  if "email" == k
        return items
      end

      def allowed_params
        params.require(:item).permit(:active,:name,:email,:phone)
      end


      # Set data for CRUD module
      @model            = ::Subscriber
      # Include CRUD module
      include B1Admin::Concerns::Crud
    end
  end
end
