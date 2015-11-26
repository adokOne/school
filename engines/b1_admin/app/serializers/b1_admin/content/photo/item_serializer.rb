module B1Admin
  module Content
    module Photo
      class ItemSerializer < ::B1Admin::BaseSerializer
        attributes :name, :id, :logo_file_name
      end
    end
  end
end
