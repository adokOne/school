module B1Admin
  module Geo
    class ContinentsController < B1Admin::ApplicationController

      def allowed_params
        translated_fields = B1Admin::LANGS.map do |l|
          ["desc_#{l}","name_#{l}"]
        end
        params.require(:item).permit(translated_fields + [:id])
      end

      # Set data for CRUD module
      @model = ::Continent
      # Include CRUD module
      include B1Admin::Concerns::Crud

    end
  end
end
