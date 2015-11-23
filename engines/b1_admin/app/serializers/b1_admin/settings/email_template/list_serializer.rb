module B1Admin
  module Settings
    module EmailTemplate
      class ListSerializer < ::ActiveModel::Serializer
        attributes :id, :subject, :active, :seo_name

      end
    end
  end
end
