module B1Admin
  module Baners
    module Page
      class ListSerializer < ::B1Admin::BaseSerializer
        attributes :title, :id,:seo_name,:active, :logo, :city_name, :category_title
      end
    end
  end
end
