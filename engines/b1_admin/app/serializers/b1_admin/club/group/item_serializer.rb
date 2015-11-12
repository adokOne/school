module B1Admin
  module School
    module Group
      class ItemSerializer < ::B1Admin::BaseSerializer
        attributes :name, :active, :id, :course_id
      end
    end
  end
end
