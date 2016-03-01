module B1Admin
  module Blog
    class PagesController < B1Admin::ApplicationController

      ##
      # Filter items by conditions
      # @return [ActiveRecord::Relation<Page>]
      ##
      def filter items , k , v
        items = items.where(category_id: v.to_i)   if "category_id" == k
        return items
      end

      def allowed_params
        params.require(:item).permit(:active,:seo_name,:category_id,:anons,:desc,:title,:author)
      end

      def set_data
        @categories = ::Category.all.map{|c| {title: c.title,id: c.id} }
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
      @model = ::Page
      @order = {position: :asc},{id: :asc}
      # Include CRUD module
      include B1Admin::Concerns::Crud

    end
  end
end
