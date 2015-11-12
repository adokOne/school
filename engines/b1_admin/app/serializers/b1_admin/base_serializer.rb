module B1Admin
  class BaseSerializer < ::ActiveModel::Serializer

    def initialize( object = nil, existed_record = true )
      super(object)
      @id = existed_record && object.present? ? object.respond_to?(:id) ? object.id : object.id : false
    end

    def id
      @id
    end

  end
end
