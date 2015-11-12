module B1Admin
  module School
    module Group
      class ListSerializer < ::ActiveModel::Serializer
        attributes :name,:active,:id, :course_name
      end
    end
  end
end
