module B1Admin
  module Settings
    module EmailTemplate
      class ItemSerializer < ::B1Admin::BaseSerializer

        attributes :id, :active, :seo_name, :subject, :desc


      end
    end
  end
end
