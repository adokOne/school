module B1Admin
  module Content
    module Vacancy
      class ItemSerializer < ::B1Admin::BaseSerializer
        attributes :name,:active,:desc,:id
      end
    end
  end
end
