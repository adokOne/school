module B1Admin
  module Content
    class TeachersController < B1Admin::ApplicationController

      def allowed_params
        params.require(:item).permit(:is_in_school,:is_in_club,:name,:desc,:id)
      end

      # Set data for CRUD module
      @model            = ::Teacher
      # Include CRUD module
      include B1Admin::Concerns::Crud
    end
  end
end
