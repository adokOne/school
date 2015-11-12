module B1Admin
  module Club
    module Subscriber
      class ItemSerializer < ::B1Admin::BaseSerializer
        attributes :name,:active,:course_id, :email, :phone,:id
      end
    end
  end
end
