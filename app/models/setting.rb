class Setting < ActiveRecord::Base

  validates :value, :key, presence: true

end
