module B1Admin
  module Geo
    class CitiesController < B1Admin::ApplicationController
      skip_before_filter :verify_authenticity_token, only: :upload
      ##
      # Filter items by conditions
      # @return [ActiveRecord::Relation<City>]
      ##
      def filter items,k,v
        items = items.where(country_id: v.to_i)         if "country_id" == k
        items = items.where(continent_id: v.to_i)       if "continent_id" == k
        items = items.where(code: v.to_s.upcase)        if "code" == k
        items = items.where(show_on_search: v.to_bool)  if "show_on_search" == k
        items = items.where(show_as_popular: v.to_bool) if "show_as_popular" == k
        items = items.where(meta_is_generated: v.to_bool) if "meta_is_generated" == k


        return items
      end

      def allowed_params
        translated_fields = I18n.available_locales.map do |l|
          ["desc_#{l}","name_#{l}","meta_keys_#{l}","meta_title_#{l}","meta_desc_#{l}"]
        end
        params.require(:item).permit( translated_fields + [:id,:time_zone,:code,:country_id,:show_on_search,:continent_id,:show_as_popular, :meta_is_generated])
      end

      def set_data
        @time_zones = []
        @countries  = ::Country.all.map{|c| {name: c.name,id: c.id} }
        @continents = ::Continent.all.map{|c| {name: c.name,id: c.id} }
      end

      # Set data for CRUD module
      @model    = ::City
      @order    = :"name_#{I18n.locale}"
      @includes = [:continent,:country]
      # Include CRUD module
      include B1Admin::Concerns::Crud

    end
  end
end
