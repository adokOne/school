module B1Admin
  module Content
    class UploadsController < B1Admin::ApplicationController
      skip_before_filter :verify_authenticity_token, only: :create
      skip_before_filter :check_access, only: :create
      

      def create
        image = UploadImage.create({ file: params[:file] })
        render json: {url: image.file}
      end

    end
  end
end