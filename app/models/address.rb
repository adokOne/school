class Address < ActiveRecord::Base


  validates :name,:title, presence: true
  validates :name,:title, length: { in: 5..255 }
  validates :active, inclusion:{ in: [true,false] }

  scope :active, -> { where(active: true) }

end
