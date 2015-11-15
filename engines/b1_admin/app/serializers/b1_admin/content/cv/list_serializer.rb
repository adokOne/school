module B1Admin
  module Content
    module Cv
      class ListSerializer < ::ActiveModel::Serializer
        attributes :name, :id, :phone, :email, :cv_exist
        def cv_exist
          self.object.document.exist?
        end
      end
    end
  end
end
