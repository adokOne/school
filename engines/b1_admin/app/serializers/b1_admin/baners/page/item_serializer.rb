module B1Admin
  module Baners
    module Page
      class ItemSerializer < ::B1Admin::BaseSerializer
        attributes :phones,:sites, :emails,  :email,:phone,:site, :anons,:desc,:title,:id,:active,:seo_name,:category_id, :logo_file_name, :logo, :city_id, :meta_is_generated, :meta_title, :meta_desc,:meta_keys, :user, :country_id, :city_is_canonical


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

        def phones
          _items = self.object.phone.to_s.split("|")
          _items.any? ? _items : [""]
        end
        def sites
          items = self.object.site.to_s.split("|")
          _items.any? ? _items : [""]
        end
        def emails
          items = self.object.email.to_s.split("|")
          _items.any? ? _items : [""]
        end

      end
    end
  end
end
