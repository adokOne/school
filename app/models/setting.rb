class Setting < ActiveRecord::Base

  validates :value, :key, presence: true


  after_update :clear_cache



  def clear_cache
    Rails.cache.clear("settings")
  end

end
