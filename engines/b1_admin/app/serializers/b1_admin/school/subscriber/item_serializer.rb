module B1Admin
  module School
    module Subscriber
      class ItemSerializer < ::B1Admin::BaseSerializer
        attributes :name,:active,:course_id, :email, :phone,:id, :level
      end
    end
  end
end
