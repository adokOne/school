module B1Admin
  module Settings
    class AddressesController < B1Admin::ApplicationController

      def allowed_params
        params.require(:item).permit(:name,:phones,:email,:id,:active,:is_main,:title)
      end

      # Set data for CRUD module
      @model      = ::Address
      # Include CRUD module
      include B1Admin::Concerns::Crud

    end
  end
end
