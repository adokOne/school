module B1Admin
  module Content
    module Photo
      class ListSerializer < ::ActiveModel::Serializer
        attributes :name, :id, :logo
      end
    end
  end
end
