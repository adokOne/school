module B1Admin
  module Settings
    module Ad
      class ItemSerializer < ::B1Admin::BaseSerializer
        attributes :id, :desc,:active,:image_file_name, :color, :text, :link
      end
    end
  end
end
