module B1Admin
  module Settings
    module Setting
      class ListSerializer < ::ActiveModel::Serializer
        attributes :id, :key,:value

      end
    end
  end
end
