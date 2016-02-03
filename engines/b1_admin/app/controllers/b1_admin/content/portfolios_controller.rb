module B1Admin
  module Content
    class PortfoliosController < B1Admin::ApplicationController

      def allowed_params
        params.require(:item).permit(:title,:category,:anons, :desc, :site,:id, :active)
      end

      def images
        images = @item.portfolio_images
        render json: {
          total: images.count,
          items: ActiveModel::ArraySerializer.new(images, each_serializer: B1Admin::Content::Portfolio::ImageSerializer)
        }
      end

      def upload
        response = success_update_response
        unless image = ::PortfolioImage.new(self.class.image_field_name.to_sym => request.params[:file])
          response = fail_update_response @item
        end
        @item.portfolio_images << image
        render json: response
      end

      def delete_image
        PortfolioImage.find(params[:image_id]).delete
        render json: success_update_response
      end

      # Set data for CRUD module
      @model            = ::Portfolio
      @additional_check_actions = [:images]
      # Include CRUD module
      include B1Admin::Concerns::Crud
    end
  end
end
