module B1Admin
  module Products
    module Transaction
      class ListSerializer < ::B1Admin::BaseSerializer
        attributes :name,:active,:product_name, :email, :phone,:id
      end
    end
  end
end
