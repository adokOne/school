module B1Admin
  module Content
    module Member
      class ItemSerializer < ::B1Admin::BaseSerializer
        attributes :name, :id, :logo_file_name, :desc
      end
    end
  end
end
