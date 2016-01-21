module B1Admin
  module Baners
    module Review
      class ListSerializer < ::B1Admin::BaseSerializer
        attributes :name,:moderated, :email, :comment,:id, :link, :page, :created_at

        def link
          self.object.page.link
        end
        def page
          self.object.page.title
        end
      end
    end
  end
end
