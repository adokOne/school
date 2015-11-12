module B1Admin
  module Settings
    module Mod
      class ItemSerializer < ::B1Admin::BaseSerializer
        attributes *([:controller, :parent_id,:ico,:id] +  B1Admin::LANGS.map{|l| :"name_#{l}"})
      end
    end
  end
end
