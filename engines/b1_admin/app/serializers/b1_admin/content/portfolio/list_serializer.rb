module B1Admin
  module Content
    module Portfolio
      class ListSerializer < ::ActiveModel::Serializer
        attributes :title,:category ,:id, :active
      end
    end
  end
end
