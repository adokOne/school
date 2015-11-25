module B1Admin
  module Geo
    class AirportsController < B1Admin::ApplicationController
      ##
      # Filter items by conditions
      # @return [ActiveRecord::Relation<Airport>]
      ##
      def filter
        items = items.where(country_id: v.to_i)         if "country_id" == k
        items = items.where(city_id: v.to_i)            if "city_id" == k
        items = items.where(code: v.to_s.upcase)        if "code" == k
        return items
      end

      def allowed_params
        params.require(:item).permit(B1Admin::LANGS.map{|l| "name_#{l}"} + [:id,:country_id,:city_id,:show_on_search,:code])
      end

      def set_data
        @time_zones = B1Config.get_const.time_zones
        @countries  = ::Country.all.map{|c| {name: c.name,id: c.id} }
      end

      # Set data for CRUD module
      @model    = ::Airport
      @order    = :"name_#{I18n.locale}"
      @includes = [:city,:country]
      # Include CRUD module
      include B1Admin::Concerns::Crud

    end
  end
end