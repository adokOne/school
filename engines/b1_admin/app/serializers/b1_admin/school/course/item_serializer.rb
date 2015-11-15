module B1Admin
  module School
    module Course
      class ItemSerializer < ::B1Admin::BaseSerializer
        attributes :name, :active, :logo_file_name,:id, :seo, :title, :date_start
      end
    end
  end
end
