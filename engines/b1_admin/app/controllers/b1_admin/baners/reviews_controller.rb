module B1Admin
  module Baners
    class ReviewsController < B1Admin::ApplicationController

      ##
      # Filter items by conditions
      # @return [ActiveRecord::Relation<Page>]
      ##
      def filter items , k , v
        items = items.where(page_id: v.to_i)   if "page_id" == k
        return items
      end

      def update
        @item.update_attribute( :moderated, true)
        render json: success_update_response
      end

      # Set data for CRUD module
      @model = ::Review
      @additional_check_actions = :show_reviews
      @order = {id: :desc}
      # Include CRUD module
      include B1Admin::Concerns::Crud

    end
  end
end
