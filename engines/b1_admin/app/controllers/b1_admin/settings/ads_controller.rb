module B1Admin
  module Settings
    class AdsController < B1Admin::ApplicationController

      def allowed_params
        params.require(:item).permit(:desc,:color,:active, :text, :link)
      end

      def after_create
        base_64 = params.dup[:item].delete("file")
        if base_64.present?
          @item.reload
          @item.image_data = base_64
          @item.save
        end
      end

      # Set data for CRUD module
      @model      = ::Ad
      @image_field_name = "image"
      # Include CRUD module
      include B1Admin::Concerns::Crud

    end
  end
end
