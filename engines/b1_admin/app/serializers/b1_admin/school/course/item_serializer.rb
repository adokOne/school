module B1Admin
  module School
    module Course
      class ItemSerializer < ::B1Admin::BaseSerializer
        attributes :name, :active, :logo_file_name,:id, :seo, :title, :date_start,:desc, :fb_link, :learn_descs, :detail_descs, :price, :period, :heading


        def detail_descs
          data = self.object.detail_desc.to_s.split("|||")
          data.any? ? data : [""]
        end

        def learn_descs
          data = self.object.learn_desc.to_s.split("|||")
          data.any? ? data : [""]
        end


      end
    end
  end
end
