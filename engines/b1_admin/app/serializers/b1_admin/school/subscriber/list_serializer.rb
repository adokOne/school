module B1Admin
  module School
    module Subscriber
      class ListSerializer < ::B1Admin::BaseSerializer
        attributes :name,:active,:course_name, :email, :phone,:id, :level, :created_at
      end
    end
  end
end
