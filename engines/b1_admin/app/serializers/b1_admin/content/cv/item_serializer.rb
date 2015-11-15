module B1Admin
  module Content
    module Cv
      class ItemSerializer < ::B1Admin::BaseSerializer
        attributes :name, :id, :phone, :email
      end
    end
  end
end
