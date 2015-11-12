module B1Admin
  module Settings
    class ModulesController < B1Admin::ApplicationController

      def index
        respond_to do |format|
          format.html do 
            render layout: !params.has_key?(:only_template)
          end
          format.json do
            items = B1Admin::Module.to_tree
            render json: {items:items}
          end
        end
      end

      ##
      # Update all modules positions or delete them
      # @raise [B1Admin::Exception] if params from JS are invalid or module is not found
      # @render [JSON]
      ##
      def update_positions
        
        raise B1Admin::Exception.new(6,{name:update_all_params.inspect,type:"Array",is_type: update_all_params.class}) unless update_all_params.kind_of?(Array)
        
        update_func = lambda do |items|
          items.each_with_index do |item,i|
            childs = item["childs"].kind_of?(Array) ? item["childs"] : []
            raise B1Admin::Exception.new(7,{text:"Item B1Admin::Module with id #{item['id']} not found"}) unless item = B1Admin::Module.find_by_id(item["id"].to_i)
            item.update_attribute(:position,i)
            update_func.call(childs)
          end
        end

        # Transaction used because update_func cay raise Exception
        B1Admin::Module.transaction do 
          update_func.call(update_all_params)
        end

        render json: success_update_response
      end


      def allowed_params
        params.require(:item).permit(B1Admin::LANGS.map{|l| "name_#{l}"} + [:ico, :parent_id, :controller,:id])
      end

      # Set data for CRUD module
      @model = B1Admin::Module
      @serializer = "Mod"
      # Include CRUD module
      include B1Admin::Concerns::Crud

      private
      def update_all_params
        params.require(:items)
      end

    end
  end
end