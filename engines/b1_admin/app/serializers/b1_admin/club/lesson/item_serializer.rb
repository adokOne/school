module B1Admin
  module Club
    module Lesson
      class ItemSerializer < ::B1Admin::BaseSerializer
        attributes :date,:active,:course_id, :time, :id
      end
    end
  end
end
