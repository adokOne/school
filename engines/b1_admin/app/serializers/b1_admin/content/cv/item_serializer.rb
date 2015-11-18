module B1Admin
  module Content
    module Cv
      class ItemSerializer < ::B1Admin::BaseSerializer
        attributes :name, :id, :phone, :email, :document_file_name
      end
    end
  end
end
