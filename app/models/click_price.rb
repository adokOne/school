class ClickPrice < ActiveRecord::Base

  scope :active, ->{where(active: true)}


  def bullets
    self.bullet.to_s.split("|")
  end
end
