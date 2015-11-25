module B1Admin
  module Geo
    class CountriesController < B1Admin::ApplicationController

      def allowed_params
        translated_fields = B1Admin::LANGS.map do |l|
          ["desc_#{l}","name_#{l}","meta_keys_#{l}","meta_title_#{l}","meta_desc_#{l}"]
        end
        params.require(:item).permit(translated_fields + [:id, :g_map_url,:code,:currency,:old_code,:continent_id, :meta_is_generated])
      end

      def set_data
        @currencies = []
        @continents = ::Continent.all.map{|c| {name: c.name,id: c.id} }
      end


      # Set data for CRUD module
      @model            = ::Country
      @order            = :"name_#{I18n.locale}"
      @image_field_name = :flag
      @includes         = [:continent]
      # Include CRUD module
      include B1Admin::Concerns::Crud

    end
  end
end
