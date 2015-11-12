module B1Admin
  module Content
    module Hotel
      class ListSerializer < ::ActiveModel::Serializer
        attributes :name, :id, :status, :moderate, :type, :city, :country, :logo, :booking_com_id, :ostrovok_id, :content_inn_id, :seo_name

        def type
          self.object.type.try(:name)
        end

        def country
          self.object.country.try(:name)
        end

        def city
          self.object.city.try(:name)
        end

        def seo_link
          [self.object.city.try(:seo_name),self.object.seo_name].join("/")
        end


      end
    end
  end
end
