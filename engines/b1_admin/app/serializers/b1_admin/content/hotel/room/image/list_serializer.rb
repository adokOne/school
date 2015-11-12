module B1Admin::Content::Hotel::Room::Image
  class ListSerializer < ::B1Admin::BaseSerializer
    attributes :id, :image_url, :description_translations, :main_image

    def image_url
      object.logo.url
    end
  end
end
