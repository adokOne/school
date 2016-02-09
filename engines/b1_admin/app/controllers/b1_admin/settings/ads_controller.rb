module B1Admin
  module Settings
    class AdsController < B1Admin::ApplicationController

      def allowed_params
        params.require(:item).permit(:desc,:color,:active,:id, :text, :link)
      end

      # Set data for CRUD module
      @model      = ::Ad
      @image_field_name = "image"
      # Include CRUD module
      include B1Admin::Concerns::Crud

    end
  end
end
