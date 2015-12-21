module B1Admin
  module Products
    module User
      class ItemSerializer < ::B1Admin::BaseSerializer
        attributes :avatar, :name,:email,:blocked,:phone,:created_at,:blocked_until,:id,:active,:signins_count,:messages_count,:address, :website

        def pages
          self.object.pages.map{ |page| {title:page.title, link: page.link }}
        end

        def phone
          self.object.phones.join(",")
        end
        def address
          self.object.addresses.join(",")
        end
        def website
          self.object.websites.join(",")
        end




      end
    end
  end
end
