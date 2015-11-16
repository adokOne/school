module B1Admin
  module Content
    module Partner
      class ItemSerializer < ::B1Admin::BaseSerializer
        attributes :name, :id, :logo_file_name, :active, :first_desc_line, :second_desc_line
      end
    end
  end
end
