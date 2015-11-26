module B1Admin
  module Baners
    module BlogPage
      class ItemSerializer < ::B1Admin::BaseSerializer
        attributes :anons,:desc,:title,:id,:active,:seo_name, :logo_file_name, :logo
      end
    end
  end
end
