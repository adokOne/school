module B1Admin
  module Baners
    module Category
      class ItemSerializer < ::B1Admin::BaseSerializer
        attributes :id,:parent_id,:seo_name,:desc,:title, :logo_file_name, :logo
      end
    end
  end
end
