module B1Admin
  module Club
    module Course
      class ItemSerializer < ::B1Admin::BaseSerializer
        attributes :name, :active, :logo_file_name,:id, :seo, :title,:desc
      end
    end
  end
end
