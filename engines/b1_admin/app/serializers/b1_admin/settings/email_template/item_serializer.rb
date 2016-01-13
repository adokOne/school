module B1Admin
  module Settings
    module EmailTemplate
      class ItemSerializer < ::B1Admin::BaseSerializer

        attributes :id, :active, :seo_name, :subject_en, :subject_ru, :subject_uk, :text_en, :text_ru, :text_uk
        attributes :text_area_name


        def text_area_name
          "text"
        end

      end
    end
  end
end
