##
# CRUD helper
# This module define functionality for CRUD actions if they are not defined in controller
# Module must be included before end of class
# thats meens the all methods must be defined before module included
# Before you include this module you must set class instance variable @model e.g. User
# You can use includes and order methods for model, just define class instance variable @includes or @order
# Methods "allowed_params" and "set_data" must be redifined but not raise any excpetions if not defined in controller
# Methods that you can redifine in controller:
# - index
# - show
# - new
# - create
# - update
# - edit
# - destroy
# - filter
# - set_data
# - upload
#
# @author Chernov Alexandr <adok@ukr.net>
##
module B1Admin
  module Concerns
    module Crud
      extend ActiveSupport::Concern

      # Default model relations to include in query
      includes = []

      # Default model order


      # Default model image field name
      image_field_name = :logo

      included do
        #Set model and image_field_name accesible
        class << self
          attr_accessor :model ,:image_field_name,:order,:includes,:serializer, :additional_permissions
          attr_reader :additional_check_actions
        end
        #Additional actions where need setup instance of model
        additional_check_actions = self.additional_check_actions.nil? ? [] : self.additional_check_actions.kind_of?(Array) ? self.additional_check_actions : [self.additional_check_actions]
        #Set default before actions
        before_filter :check_item, only: [:edit,:destroy,:update,:upload,:show] + additional_check_actions

        #Set additional data before actions
        before_filter :set_data, only:[:edit,:new,:index]


        #Scip token in upload actions
        skip_before_filter :verify_authenticity_token, only: :upload

        #Check if @model is defined in controller
        raise "You must set @model before include this module" if self.model.nil?

        order    = self.model < ActiveRecord::Base ? [{id: :asc}] : :id.asc

        # This methods must be public in controller, they set to private in this module
        %w(set_data).each do |method|
          raise "Visability of #{self.name}::#{method} must be public" if self.private_methods.include?(method.to_sym)
        end

        # Check model and queries attributes
        # Set to default if not defined

        self.includes   = self.includes.nil?   ? includes : self.includes
        self.order      = self.order.nil?      ? order    : self.order
        self.serializer = self.serializer.nil? ? self.model.name : self.serializer
        self.image_field_name = self.image_field_name.nil?  ? image_field_name : self.image_field_name
        self.additional_permissions = self.additional_permissions.nil?  ? [] : self.additional_permissions

        # Get all defined methods in controller
        methods = self.instance_methods(false)

        # Check if method defined in controller
        # If method not exist define default method
        unless methods.include?(:index)
          define_method(:index) do
            @conditions = @conditions || {}
            respond_to do |format|
              format.html do
                render layout: !params.has_key?(:only_template)
              end
              format.json do
                items   = self.class.model.where(@conditions).includes(self.class.includes).order(self.class.order)
                # Set filters to default or get their from params
                filters = params[:filters].present? ? ActiveSupport::JSON.decode(params[:filters]) : {} rescue {}
                # Set conditions
                filters.each_pair do |k,v|
                  items = filter items,k,v
                end
                render json: {total: items.count, items: ActiveModel::ArraySerializer.new(items.page(params[:page]).to_a, each_serializer:  "#{self.class.name.deconstantize}::#{self.class.serializer}::ListSerializer".constantize )}
              end
            end
          end
        end


        unless methods.include?(:new)
          ##
          # Render a view
          ##
          define_method(:new) do
            @item = self.class.model.new
            p "#{self.class.name.deconstantize}::#{self.class.serializer}::ItemSerializer"
            @item = "#{self.class.name.deconstantize}::#{self.class.serializer}::ItemSerializer".constantize.new(@item,false)
            render layout: !params.has_key?(:only_template)
          end
        end

        unless methods.include?(:show)
          ##
          # Get item by id
          # params:
          #   id - item id [Integer]
          # @render [JSON]
          ##
          define_method(:show) do
            @item = "#{self.class.name.deconstantize}::#{self.class.serializer}::ItemSerializer".constantize.new(@item).serializable_hash
            render json: @item
          end
        end

        unless methods.include?(:edit)
          define_method(:edit) do
            @item = "#{self.class.name.deconstantize}::#{self.class.serializer}::ItemSerializer".constantize.new(@item)
            render layout: !params.has_key?(:only_template)
          end
        end

        unless methods.include?(:update)
          ##
          # Update one item finded by id
          # @render [JSON]
          ##
          define_method(:update) do
            @params_to_update = allowed_params.dup
            response = success_update_response
            ActiveRecord::Base.transaction do
              before_update

              unless @item.update_attributes(@params_to_update)
                response = fail_update_response @item
              end

              after_update
            end
            render json: response
          end
        end

        unless methods.include?(:create)
          ##
          # Create new item
          # @render [JSON]
          ##
          define_method(:create) do
            @params_to_create = allowed_params.dup
            item  = self.class.model.new(@params_to_create)
            response = success_update_response
            unless item.valid? && item.save
              response = fail_update_response item
            end

            render json: response
          end
        end

        unless methods.include?(:destroy)
          ##
          # Destroy item by id
          # params:
          #   id - Item id [Integer]
          # @render [JSON]
          ##
          define_method(:destroy) do
            render json: @item.destroy ? success_delete_response : {success: false}
          end
        end

        unless methods.include?(:upload)
          ##
          # Set item image, if
          # params:
          #   file - image
          # @render [JSON]
          ##
          define_method(:upload) do
            response = success_update_response
            unless @item.update_attributes(self.class.image_field_name.to_sym => request.params[:file])
              response = fail_update_response @item
            end
            render json: response
          end
        end

        unless methods.include?(:allowed_params)
          ##
          # Set default allowed params to update or create item
          ##
          define_method(:allowed_params) do
            params.require(:item).permit([])
          end
        end

        unless methods.include?(:set_data)
          ##
          # Set additional instance data
          ##
          define_method(:set_data) do

          end
        end

        unless methods.include?(:filter)
          ##
          # Filter
          ##
          define_method(:filter) do |items,k,v|
            items
          end
        end
        unless methods.include?(:before_update)
          ##
          # Before model update callback
          ##
          define_method(:before_update) do
          end
        end
        unless methods.include?(:after_update)
          ##
          # After model update callback
          ##
          define_method(:after_update) do
          end
        end

        self.additional_permissions.each do |meth|
          define_method(meth) do
          end
        end

        def partner_access_prefilter
          @conditions = @conditions || {}
        end

        def owner_access_prefilter
          @conditions = @conditions || {}
        end



        self.send :private, :check_item
        self.send :private, :allowed_params
        self.send :private, :set_data
        self.send :private, :filter
        self.send :private, :before_update
        self.send :private, :after_update
        self.send :private, :partner_access_prefilter
        self.send :private, :owner_access_prefilter
      end


      ##
      # Set instance @item by id from params or raise exception
      # @raise  [B1Admin::Exception] if log row is not found
      ##
      def check_item
        raise B1Admin::Exception.new(7,{text:"Item #{self.class.model.class.name} with id #{params['id']} not found"}) unless @item = self.class.model.find(params[:id].to_s)
      end

    end
  end
end
