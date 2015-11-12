module B1Admin
  module Content
    class VacanciesController < B1Admin::ApplicationController

      def allowed_params
        params.require(:item).permit(:active,:name,:desc)
      end

      # Set data for CRUD module
      @model            = ::Vacancy
      # Include CRUD module
      include B1Admin::Concerns::Crud
    end
  end
end
