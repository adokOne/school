class Translation < ActiveRecord::Base
  validates :key,:value, presence: true
  attr_accessor :translations
  class << self
    attr_accessor :translations
  end

  def self.get
    @translations ||= Translation.all.pluck(:key,:value).to_h
  end
end
