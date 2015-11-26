module B1Admin
  module Products
    module Order
      class ListSerializer < ::B1Admin::BaseSerializer
        attributes :created_at, :product_name, :id, :product_id
      end
    end
  end
end
