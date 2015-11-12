module B1Admin
  module Content
    module Partner
      class ItemSerializer < ::B1Admin::BaseSerializer
        attributes :name, :id, :logo_file_name, :active
      end
    end
  end
end
