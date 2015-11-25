module B1Admin
  module Settings
    class EmailsController < B1Admin::ApplicationController

      ##
      # Filter items by conditions
      # @return [ActiveRecord::Relation<City>]
      ##
      def filter items,k,v
        items = items.where(seo_name: v.to_s.downcase) if "seo_name" == k
        return items
      end

      def allowed_params
        params.require(:item).permit(:id,:agent_id,:seo_name,:active,{text_translations:I18n.available_locales},{subject_translations:I18n.available_locales}, {available_tags:[]})
      end


      # Set data for CRUD module
      @model            = ::EmailTemplate

      @additional_permissions = [:add_tags]

      # Include CRUD module
      include B1Admin::Concerns::Crud

    end
  end
end
