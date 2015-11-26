module B1Admin
  module Products
    module Page
      class ListSerializer < ::B1Admin::BaseSerializer
        attributes :title, :id,:seo_name,:active
      end
    end
  end
end
