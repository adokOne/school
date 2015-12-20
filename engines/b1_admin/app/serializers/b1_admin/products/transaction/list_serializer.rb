module B1Admin
  module Products
    module Transaction
      class ListSerializer < ::B1Admin::BaseSerializer
        attributes :name,:status, :email, :phone,:id, :amount, :description, :created_at

        def name
          self.object.user.try(:name)
        end

        def email
          self.object.user.try(:email)
        end

        def phone
          self.object.user.try(:phone)
        end

      end
    end
  end
end
