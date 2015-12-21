module B1Admin
  module Products
    module Transaction
      class ItemSerializer < ::B1Admin::BaseSerializer
        attributes :status, :id, :amount, :description, :created_at, :product_id, :user

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
