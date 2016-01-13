module B1Admin
  module Baners
    module Page
      class ItemSerializer < ::B1Admin::BaseSerializer
        attributes :anons,:desc,:title,:id,:active,:seo_name,:category_id, :logo_file_name, :logo, :city_id, :meta_is_generated, :meta_title, :meta_desc,:meta_keys, :user, :country_id, :city_is_canonical


        def user
          if self.object.user.present?
            {
              name:self.object.user.name,
              email:self.object.user.email,
              id:self.object.user.id,
            }
          else
            {}
          end
        end
      end
    end
  end
end
