module B1Admin
  module Content
    module Teacher
      class ListSerializer < ::ActiveModel::Serializer
        attributes :name, :id, :logo, :is_in_school, :is_in_club
      end
    end
  end
end
