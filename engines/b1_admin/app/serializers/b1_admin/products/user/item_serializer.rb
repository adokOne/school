module B1Admin
  module Products
    module User
      class ItemSerializer < ::B1Admin::BaseSerializer
        attributes :created_at, :email, :id, :name
      end
    end
  end
end
