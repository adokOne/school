module B1Admin
  module Settings
    module EmailTemplate
      class ItemSerializer < ::B1Admin::BaseSerializer

        attributes :id, :active, :seo_name, :subject_translations, :text_translations, :available_tags
        attributes :is_mongoid_localize, :text_area_name, :tags

        def is_mongoid_localize
          true
        end
        def text_area_name
          "text"
        end

        def tags
          self.object.available_tags.inject({}){|hash,item| hash.merge!({item.to_s.to_sym => true})}
        end

      end
    end
  end
end
