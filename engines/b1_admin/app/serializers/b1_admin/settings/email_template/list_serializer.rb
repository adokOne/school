module B1Admin
  module Settings
    module EmailTemplate
      class ListSerializer < ::ActiveModel::Serializer
        attributes :id, :subject, :active, :seo_name, :agent

        def agent
          Agent.find(self.object.agent) rescue I18n.t("b1_admin.common")
        end
      end
    end
  end
end
