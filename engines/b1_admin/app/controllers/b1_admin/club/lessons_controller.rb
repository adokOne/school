module B1Admin
  module Club
    class LessonsController < B1Admin::ApplicationController

      def allowed_params
        params.require(:item).permit( :course_id, :date, :time, :id )
      end

      def show
        hotel = ::Hotel.includes(:rooms).find(params[:id])
        rooms = ::Hotel.find(params[:id]).rooms
        rooms = rooms.where(:hotelier_id.in current_admin.get_hoteliers_ids) if current_admin.is_partner? || current_admin.contract_owner?
        @rooms = ActiveModel::ArraySerializer.new(
            rooms,
            each_serializer: "#{self.class.name.deconstantize}::Hotel::Room::ListSerializer".constantize
        )
        respond_to do |format|
          format.html
          format.json { render json: { total: rooms.count, items: @rooms } }
        end
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
      @model = ::Lesson.for_club
      # Include CRUD module
      include B1Admin::Concerns::Crud
    end
  end
end
