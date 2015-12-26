module B1Admin
  module Baners
    class PagesController < B1Admin::ApplicationController

      ##
      # Filter items by conditions
      # @return [ActiveRecord::Relation<Page>]
      ##
      def filter items , k , v
        items = items.where(category_id: v.to_i)   if "category_id" == k
        items = items.where(city_id: v.to_i)   if "city_id" == k
        return items
      end

      def allowed_params
        params.require(:item).permit(:city_is_canonical, :id,:active,:seo_name,:category_id,:anons,:desc,:title, :city_id, :meta_is_generated, :meta_title, :meta_desc,:meta_keys, :user_id, :country_id)
      end

      def set_data
        @categories = ::Category.order("title_ru ASC").all.map{|c| {title: c.title,id: c.id} }
        @cagegoties_tree = Category.to_tree
        @cities = ::City.where(country_id: Country::UKRAINE_ID ).all.map{|c| {name: c.name,id: c.id} }
        @countries = ::Country.all.map{|c| {name: c.name,id: c.id} }
      end

      def before_update
        user = params.dup[:item].delete("user")
        if user.kind_of?(Hash) && user["originalObject"].present?
          @params_to_update[:user_id] = user["originalObject"]["id"]
        end
      end

      # Set data for CRUD module
      @model = ::Page
      @order = {position: :asc},{id: :asc}
      # Include CRUD module
      include B1Admin::Concerns::Crud

    end
  end
end
