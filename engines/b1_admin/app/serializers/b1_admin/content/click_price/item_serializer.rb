module B1Admin
  module Content
    module ClickPrice
      class ItemSerializer < ::B1Admin::BaseSerializer
        attributes :plus,:desc,:title, :id, :bullets, :price, :active


        def bullets
          data = object.bullet.to_s.split("|")
          data.any? ? data : [""]
        end
      end
    end
  end
end
