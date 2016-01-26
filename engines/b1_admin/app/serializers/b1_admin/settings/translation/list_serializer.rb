module B1Admin
  module Settings
    module Translation
      class ListSerializer < ::ActiveModel::Serializer
        attributes :id, :key,:value
      end
    end
  end
end
