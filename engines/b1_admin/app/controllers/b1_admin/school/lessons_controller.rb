module B1Admin
  module School
    class LessonsController < B1Admin::ApplicationController

      def allowed_params
        params.require(:item).permit( :course_id, :date, :time, :id )
      end

      def index
        respond_to do |format|
          format.html do
            render layout: !params.has_key?(:only_template)
          end
          format.json do
            items   = self.class.model.all.inject({}) do |items,item|
              items[item.course_id] = {} unless items[item.course_id].present?
              items[item.course_id][item.date] = "#{self.class.name.deconstantize}::#{self.class.model.name}::ListSerializer".constantize.new(item)
              items
            end

            render json: {total: items.count, items: items }
          end
        end
      end

      # Set data for CRUD module
      @model = ::Lesson.for_school
      # Include CRUD module
      include B1Admin::Concerns::Crud
    end
  end
end
