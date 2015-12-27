module B1Admin
  module Content
    module Feedback
      class ItemSerializer < ::B1Admin::BaseSerializer
        attributes :name, :id, :phone, :email, :message
      end
    end
  end
end
