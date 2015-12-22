module B1Admin
  module Products
    module Order
      class ListSerializer < ::B1Admin::BaseSerializer
        attributes :created_at, :product_name, :id, :product_id, :page_id, :user_name, :page_name, :amount, :manager, :id, :status

        def user_name
          self.object.user.try(:name)
        end

        def page_name
          self.object.page.try(:title)
        end

        def product_name
          self.object.product.try(:name)
        end

        def manager
          B1Admin::User.find_by_id(self.object.admin_id).try(:name)
        end

      end
    end
  end
end
