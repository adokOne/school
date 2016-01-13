module B1Admin
  module Baners
    class BlogsController < B1Admin::ApplicationController


      def allowed_params
        params.require(:item).permit(:id,:active,:seo_name,:anons,:desc,:title,:meta_is_generated, :meta_title, :meta_desc,:meta_keys)
      end

      # Set data for CRUD module
      @model = ::BlogPage
      @order = {id: :desc}
      # Include CRUD module
      include B1Admin::Concerns::Crud

    end
  end
end
