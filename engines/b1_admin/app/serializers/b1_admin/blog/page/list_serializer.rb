module B1Admin
  module Blog
    module Page
      class ListSerializer < ::B1Admin::BaseSerializer
        attributes :title, :id,:seo_name,:active
      end
    end
  end
end
