module B1Admin
  module Settings
    module Translation
      class ItemSerializer < ::B1Admin::BaseSerializer
        attributes :value_en, :value_ru, :value_uk, :id
      end
    end
  end
end
