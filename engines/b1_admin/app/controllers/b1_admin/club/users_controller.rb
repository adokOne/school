module B1Admin
  module Club
    class UsersController < B1Admin::ApplicationController

      ##
      # Filter items by conditions
      # @return [ActiveRecord::Relation<City>]
      ##
      def filter items,k,v
        items = items.where(course_id: v)       if "course_id" == k
        items = items.where(email: v.to_s)  if "email" == k
        return items
      end

      def allowed_params
        params.require(:item).permit(:active,:name,:email,:phone,:course_id,:club_subscribe)
      end

      def set_data
        @courses  = ::Course.for_club.map{|c| {name: c.name,id: c.id} }
      end

      # Set data for CRUD module
      @model            = ::Subscriber.for_club
      # Include CRUD module
      include B1Admin::Concerns::Crud
    end
  end
end
