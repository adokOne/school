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
        params.require(:item).permit(:desc,:id,:parent_id,:title, :only_photos)
      end

      def set_data
        @categories = ::Category.where(parent_id:0,only_photos:true).all.map{|c| {title: c.title,id: c.id} }
      end

      # Set data for CRUD module
      @model = ::Category
      # Include CRUD module
      include B1Admin::Concerns::Crud

    end
  end
end
