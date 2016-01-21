module B1Admin
  module Baners
    module Page
      class ListSerializer < ::B1Admin::BaseSerializer
        attributes :title, :id,:seo_name,:active, :logo, :city_name, :category_title, :created_at ,:user

        def user
          [self.object.user.try(:email), self.object.user.try(:phone_contacts)].compact.join(", ")
        end
      end
    end
  end
end
