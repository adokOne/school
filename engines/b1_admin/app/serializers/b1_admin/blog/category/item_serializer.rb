module B1Admin
  module Blog
    module Category
      class ItemSerializer < ::B1Admin::BaseSerializer
        attributes :id,:parent_id,:seo_name,:desc,:title, :only_photos
      end
    end
  end
end
