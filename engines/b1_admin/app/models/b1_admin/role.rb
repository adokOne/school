module B1Admin
  class Role < ActiveRecord::Base
    after_update :update_users

    includes :modules
    #Relations
    has_and_belongs_to_many :users
    has_and_belongs_to_many :permissions, autosave: true
    has_and_belongs_to_many :modules, autosave: true
    #End Relations

    #Validates
    validates :name,      length: { in: 5..30 },format: {with:/\A^[^0-9`!@#\$%\^&*+_=]+\z/i}, presence: true
    %w{uk ru}.each do |l|
    	validates :"desc_#{l}", length: { in: 10..50},format: {with:/\A^[^`!@#\$%\^&*+_=]+\z/i}
  	end
    #End validates

    def desc
      read_attribute "desc_#{I18n.locale}"
    end

    # Get all parent modules that has relation with current role
		# @retrun [Array<B1Admin::Module>]
    def parent_modules
      self.modules.where(parent_id:0)
    end

    def update_users
      self.users.each &:save
    end
  end
end
