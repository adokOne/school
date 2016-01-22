module B1Admin
  module Settings
    class SettingsController < B1Admin::ApplicationController

      def allowed_params
        params.require(:item).permit(:key,:value)
      end


      # Set data for CRUD module
      @model      = ::Setting
      # Include CRUD module
      include B1Admin::Concerns::Crud

    end
  end
end
