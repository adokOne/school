module B1Admin
  module Baners
    module BlogPage
      class ListSerializer < ::B1Admin::BaseSerializer
        attributes :title, :id,:seo_name,:active, :logo
      end
    end
  end
end
