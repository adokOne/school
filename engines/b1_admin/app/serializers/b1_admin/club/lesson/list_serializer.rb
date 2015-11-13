module B1Admin
  module Club
    module Lesson
      class ListSerializer < ::B1Admin::BaseSerializer
        attributes :date,:time,:course_name, :active,:id, :course_id
      end
    end
  end
end
