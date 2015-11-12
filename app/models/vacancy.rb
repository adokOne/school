class Vacancy < ActiveRecord::Base



  validates :name,:desc, presence: true
  validates :name,     length: { in: 5..255 }, format: {with:/\A^[^0-9`!@#\$%\^&*+_=]+\z/i}

  validates :active, inclusion:{ in: [true,false] }


  scope :active, -> { where(active: true) }

end
