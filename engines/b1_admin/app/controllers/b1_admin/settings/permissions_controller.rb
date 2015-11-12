module B1Admin
  module Settings
    class PermissionsController < B1Admin::ApplicationController

      ##
      # Render view or return json of modules-permissions tree
      # @render [JSON]
      ##
      def index
        respond_to do |format|
          format.html do 
            render layout: !params.has_key?(:only_template)
          end
          format.json do
            items = B1Admin::Module.to_permission_tree
            render json: {items:items}
          end
        end
      end

      ##
      # Get module actions
      # params:
      #   id - Module id [Integer]
      # @raise  [B1Admin::Exception] if module is not found
      # @render [JSON<Array[String]>]
      ##
      def actions
        raise B1Admin::Exception.new(7,{text:"Item B1Admin::Module with id #{params['id']} not found"}) unless item = B1Admin::Module.find_by_id(params[:id].to_i)
        render json: {success: true, actions: item.get_controller_actions}
      end
     
      def allowed_params
        params.require(:item).permit(B1Admin::LANGS.map{|l| "desc_#{l}"} + [:action,:id,:module_id])
      end

      # Set data for CRUD module
      @model = B1Admin::Permission
      @serializer = "Permission"
      # Include CRUD module
      include B1Admin::Concerns::Crud
    end
  end
end