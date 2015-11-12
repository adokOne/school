module B1Admin
  module Content
    module Vacancy
      class ListSerializer < ::ActiveModel::Serializer
        attributes :name,:active,:id
      end
    end
  end
end
