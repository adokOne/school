module B1Admin
  module Settings
    module Permission
      class ItemSerializer < ::B1Admin::BaseSerializer
        attributes *([:module_id, :action,:id] +  B1Admin::LANGS.map{|l| :"desc_#{l}"})
      end
    end
  end
end
