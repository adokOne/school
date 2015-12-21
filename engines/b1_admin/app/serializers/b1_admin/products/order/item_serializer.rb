module B1Admin
  module Products
    module Order
      class ItemSerializer < ::B1Admin::BaseSerializer
        attributes :created_at, :product_id, :id, :product_id, :page_id, :user_name,  :amount, :user, :status

        def user_name
          self.object.user.try(:name)
        end

        def page_name
          self.object.page.try(:name)
        end

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
