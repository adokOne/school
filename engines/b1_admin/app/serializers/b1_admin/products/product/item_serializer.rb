module B1Admin
  module Products
    module Product
      class ItemSerializer < ::B1Admin::BaseSerializer
        attributes :name, :active, :logo_file_name,:id, :title, :desc
      end
    end
  end
end
