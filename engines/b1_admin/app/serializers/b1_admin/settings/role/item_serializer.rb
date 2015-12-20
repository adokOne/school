module B1Admin
  module Settings
    module Role
      class ItemSerializer < ::B1Admin::BaseSerializer
        attributes *([:id, :name] +  %w{uk ru}.map{|l| :"desc_#{l}"}),:permissions
        has_many :modules

        def permissions
          self.object.permission_ids.inject({}){|hash,item| hash.merge!({item.to_s.to_sym => true})}
        end

      end
    end
  end
end
