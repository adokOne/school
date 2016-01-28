module B1Admin
  module Settings
    class TranslationsController < B1Admin::ApplicationController

      before_action :set_conditions
      ##
      # Filter items by conditions
      # @return [ActiveRecord::Relation<City>]
      ##
      def filter items,k,v
        items = items.where("`key` LIKE 'uex%'")
        return items
      end

      def allowed_params
        params.require(:item).permit(:id,:value_en, :value_ru, :value_uk)
      end


      # Set data for CRUD module
      @model            = ::Translation

      # Include CRUD module
      include B1Admin::Concerns::Crud


      private

      def set_conditions
        @conditions = "`key` LIKE 'uex%'"
      end

      def after_update
        ::Translation.translations = ::Translation.all.pluck(:key,:value).to_h
      end
    end
  end
end
