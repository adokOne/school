module B1Admin
  module Content
    class FeedbacksController < B1Admin::ApplicationController

        # Set data for CRUD module
        @model            = ::Feedback
        # Include CRUD module
        include B1Admin::Concerns::Crud
    end
  end
end
