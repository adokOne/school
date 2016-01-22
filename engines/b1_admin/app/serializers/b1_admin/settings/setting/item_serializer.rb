module B1Admin
  module Settings
    module Setting
      class ItemSerializer < ::B1Admin::BaseSerializer
        attributes :id,:key,:value
      end
    end
  end
end
