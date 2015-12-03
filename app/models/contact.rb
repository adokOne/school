class Contact < ActiveRecord::Base

  TYPES = [
    "phone",
    "email",
    "address",
    "website"
  ]

  belongs_to :user



end
