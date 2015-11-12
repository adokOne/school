module B1Admin
  module Content
    module Partner
      class ListSerializer < ::ActiveModel::Serializer
        attributes :name, :id, :active, :logo
      end
    end
  end
end
