module B1Admin
  module Settings
    class AdminsController < B1Admin::ApplicationController
      
      ##
      # User log history
      # @render [JSON]
      ##
      def history
        render json: {success: true,total: @item.logs.count, items: ActiveModel::ArraySerializer.new(@item.logs.page(params[:page]), each_serializer: B1Admin::Logs::ListSerializer) }
      end

      def before_update
        @item.roles = []
        @item.save
      end

      def set_data
        @roles = ActiveModel::ArraySerializer.new(B1Admin::Role.all, each_serializer: B1Admin::Settings::Role::ListSerializer).serializable_array
      end
      
      def allowed_params
        params.require(:item).permit(:active,:signins_count,:blocked,:position,:phone,:email,:name,:id,:password,:password_confirmation,{role_ids: []})
      end

      # Set data for CRUD module
      @model            = B1Admin::User
      @image_field_name = :avatar
      @serializer       = "Admins"
      @additional_check_actions = :history
      # Include CRUD module
      include B1Admin::Concerns::Crud

    end
  end
end