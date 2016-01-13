module B1Admin
  module Baners
    module BlogPage
      class ItemSerializer < ::B1Admin::BaseSerializer
        attributes :anons,:desc,:title,:id,:active,:seo_name, :logo_file_name, :logo, :meta_is_generated, :meta_title, :meta_desc,:meta_keys
      end
    end
  end
end
