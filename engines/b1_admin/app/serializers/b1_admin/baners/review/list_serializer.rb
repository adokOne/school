module B1Admin
  module Baners
    module Review
      class ListSerializer < ::B1Admin::BaseSerializer
        attributes :name,:moderated, :email, :comment,:id
      end
    end
  end
end
