module B1Admin
  module Settings
    module Address
      class ItemSerializer < ::B1Admin::BaseSerializer
        attributes :id,:name,:phones,:email, :active, :is_main, :title
      end
    end
  end
end
