module B1Admin
  module Products
    module Transaction
      class ItemSerializer < ::B1Admin::BaseSerializer
        attributes :name,:active,:product_id, :email, :phone,:id
      end
    end
  end
end
