module B1Admin
  module Club
    module Subscriber
      class ListSerializer < ::B1Admin::BaseSerializer
        attributes :name,:active,:course_name, :email, :phone,:id
      end
    end
  end
end
