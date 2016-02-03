module B1Admin
  module Settings
    module Ad
      class ListSerializer < ::ActiveModel::Serializer
        attributes :id, :desc,:active,:image

        def image
          self.object.image.to_s
        end
      end
    end
  end
end
