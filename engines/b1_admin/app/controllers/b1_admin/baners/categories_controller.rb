module B1Admin
  module Baners
    class CategoriesController < B1Admin::ApplicationController

      def index
        respond_to do |format|
          format.html do
            render layout: !params.has_key?(:only_template)
          end
          format.json do
            items = ::Category.to_tree
            render json: {items:items}
          end
        end
      end

      def allowed_params

        translated_fields = I18n.available_locales.map do |l|
          ["desc_#{l}","title_#{l}","meta_keys_#{l}","meta_title_#{l}","meta_desc_#{l}"]
        end

        params.require(:item).permit(translated_fields + [:id,:parent_id,:meta_is_generated])
      end

      def set_data
        @categories = ::Category.where(parent_id:0).all.map{|c| {title: c.title,id: c.id} }
      end

      # Set data for CRUD module
      @model = ::Category
      # Include CRUD module
      include B1Admin::Concerns::Crud

    end
  end
end
