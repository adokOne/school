module B1Admin
  module Club
    class CoursesController < B1Admin::ApplicationController

      def allowed_params
        params.require(:item).permit(:active,:name,:course_type,:seo,:title)
      end

      # Set data for CRUD module
      @model            = ::Course.for_club
      # Include CRUD module
      include B1Admin::Concerns::Crud
    end
  end
end
