module B1Admin
  module Content
    module Portfolio
      class ImageSerializer < ::B1Admin::BaseSerializer
        attributes :id, :image_url

        def image_url
          object.logo.to_s
        end
      end
    end
  end
end
