module B1Admin
  module Products
    module Order
      class ItemSerializer < ::B1Admin::BaseSerializer
        attributes :active,:product_id, :created_at, :id
      end
    end
  end
end
