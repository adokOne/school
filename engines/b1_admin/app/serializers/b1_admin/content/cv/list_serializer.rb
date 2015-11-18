module B1Admin
  module Content
    module Cv
      class ListSerializer < ::ActiveModel::Serializer
        attributes :name, :id, :phone, :email, :cv_exist, :document_file_name
        def cv_exist
          self.object.document?
        end
      end
    end
  end
end
