module B1Admin
  module Content
    class MembersController < B1Admin::ApplicationController

      def allowed_params
        params.require(:item).permit(:name,:desc,:id)
      end

      # Set data for CRUD module
      @model            = ::Member
      # Include CRUD module
      include B1Admin::Concerns::Crud
    end
  end
end
