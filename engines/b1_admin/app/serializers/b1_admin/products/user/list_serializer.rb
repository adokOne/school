module B1Admin
  module Products
    module User
      class ListSerializer < ::ActiveModel::Serializer
        attributes :created_at, :avatar, :name,:email,:blocked,:phone,:created_at,:blocked_until,:id,:active,:signins_count, :balance, :pages_count, :is_vip, :total_payed

        def phone
          self.object.phones.push(self.object.phone).join(",")
        end

        def pages_count
          self.object.pages.count
        end
      end
    end
  end
end
