module B1Admin
  module Blog
    module Subscriber
      class ListSerializer < ::B1Admin::BaseSerializer
        attributes :name,:active,:course_name, :email, :phone,:id
      end
    end
  end
end
