module B1Admin
  module Settings
    module Address
      class ListSerializer < ::ActiveModel::Serializer
        attributes :id, :name,:email,:phones, :active, :is_main, :title
      end
    end
  end
end
