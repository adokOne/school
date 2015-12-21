module B1Admin
  module Products
    class UsersController < B1Admin::ApplicationController


      def filter items,k,v
        items = items.where("email LIKE ?","%#{params[:term]}%") if params[:term].present?
        return items
      end

      def allowed_params
        params.require(:item).permit( :name,:email,:blocked,:phone,:active,:address, :website )
      end

      def before_update
        contacts = []
        @params_to_update.delete(:phone).to_s.split(",").compact.each do |item|
          contacts << {value: item, contact_type: Contact::PHONE_TYPE}
        end
        @params_to_update.delete(:address).to_s.split(",").compact.each do |item|
          contacts << {value: item, contact_type: Contact::ADDRESS_TYPE}
        end
        @params_to_update.delete(:website).to_s.split(",").compact.each do |item|
          contacts << {value: item, contact_type: Contact::WEBSITE_TYPE}
        end
        ::User.transaction do
          @item.contacts.map(&:destroy)
          p contacts
          @item.contacts.create(contacts)
        end
      end

      # Set data for CRUD module
      @model = ::User
      @image_field_name = :avatar
      # Include CRUD module
      include B1Admin::Concerns::Crud
    end
  end
end
