module B1Admin
  module Content
    class FeedbacksController < B1Admin::ApplicationController


        def update
          @item.update_attributes( processed: true, admin_id: current_admin.id )
          render json: success_update_response
        end
        # Set data for CRUD module
        @model            = ::Feedback
        @additional_check_actions = :set_processed
        @order = {id: :desc}
        # Include CRUD module
        include B1Admin::Concerns::Crud
    end
  end
end
