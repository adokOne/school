module B1Admin
  module Settings
    module Role
      class ListSerializer < ::ActiveModel::Serializer
        attributes :id, :name,:desc,:permissions

        def permissions
          self.object.permissions.map(&:desc).join(".      ").html_safe
        end

      end
    end
  end
end