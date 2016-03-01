module B1Admin
  module School
    class CoursesController < B1Admin::ApplicationController


      def allowed_params
        params.require(:item).permit(:active,:name,:course_type,:seo,:title,:date_start,:desc,:fb_link, :learn_desc, :detail_desc, :price, :period, :heading)
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
      @model            = ::Course.for_school
      # Include CRUD module
      include B1Admin::Concerns::Crud
    end
  end
end
