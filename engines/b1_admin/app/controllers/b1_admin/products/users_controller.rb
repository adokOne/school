module B1Admin
  module Products
    class UsersController < B1Admin::ApplicationController


      def filter items,k,v
        items = items.where("email LIKE ?","%#{params[:term]}%") if params[:term].present?
        return items
      end

      def allowed_params
        params.require(:item).permit( :email, :name )
      end


      # Set data for CRUD module
      @model = ::User
      # Include CRUD module
      include B1Admin::Concerns::Crud
    end
  end
end
