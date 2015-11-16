module B1Admin
  module Content
    class PartnersController < B1Admin::ApplicationController

        def allowed_params
          params.require(:item).permit(:name,:id,:active, :first_desc_line, :second_desc_line)
        end

        # Set data for CRUD module
        @model            = ::Partner
        # Include CRUD module
        include B1Admin::Concerns::Crud
    end
  end
end
