module B1Admin
  module Settings
    class RolesController < B1Admin::ApplicationController

      def before_update
        @item.modules = []
        @item.permissions = []
      end
      
      def allowed_params
        params.require(:item).permit(B1Admin::LANGS.map{|l| "desc_#{l}"} + [{module_ids: []},{permission_ids: []},:name])
      end

      def set_data
        @modules = B1Admin::Module.to_permission_tree
      end

      # Set data for CRUD module
      @model      = B1Admin::Role
      @serializer = "Role"
      # Include CRUD module
      include B1Admin::Concerns::Crud

    end
  end
end