module B1Admin
  module Baners
    module Subscriber
      class ListSerializer < ::B1Admin::BaseSerializer
        attributes :name,:active, :email, :phone,:id
      end
    end
  end
end
