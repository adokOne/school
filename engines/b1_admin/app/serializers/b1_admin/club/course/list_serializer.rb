module B1Admin
  module Club
    module Course
      class ListSerializer < ::ActiveModel::Serializer
        attributes :name,:logo,:active,:id
      end
    end
  end
end
