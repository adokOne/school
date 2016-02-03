module B1Admin
  module Content
    class PricesController < B1Admin::ApplicationController

      def allowed_params
        params.require(:item).permit(:plus,:desc,:title, :id, :bullet, :price, :active)
      end

      # Set data for CRUD module
      @model            = ::ClickPrice
      # Include CRUD module
      include B1Admin::Concerns::Crud
    end
  end
end
