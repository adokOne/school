module B1Admin
  module Content
    module Teacher
      class ItemSerializer < ::B1Admin::BaseSerializer
        attributes :name, :id, :logo_file_name, :is_in_school, :is_in_club,:desc
      end
    end
  end
end
