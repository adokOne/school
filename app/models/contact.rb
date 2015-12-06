class Contact < ActiveRecord::Base

  PHONE_TYPE = "phone"
  EMAIL_TYPE = "email"
  ADDRESS_TYPE = "address"
  WEBSITE_TYPE = "website"

  TYPES = [
    PHONE_TYPE,
    EMAIL_TYPE,
    ADDRESS_TYPE,
    WEBSITE_TYPE
  ]

  belongs_to :user



end
