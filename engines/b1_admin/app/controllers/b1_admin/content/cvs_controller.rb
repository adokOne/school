module B1Admin
  module Content
    class CvsController < B1Admin::ApplicationController

        # Set data for CRUD module
        @model            = ::Cv.order(id: :desc)
        # Include CRUD module
        include B1Admin::Concerns::Crud
    end
  end
end
