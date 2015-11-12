module B1Admin
  module Content
    module Photo
      class ItemSerializer < ::B1Admin::BaseSerializer
        attributes :name, :id, :logo_file_name, :is_in_school, :is_in_club
      end
    end
  end
end
