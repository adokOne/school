class Cv < ActiveRecord::Base

  validates :name,:phone,:email, presence: true
  validates :name,     length: { in: 3..50 }, format: {with:/\A^[^0-9`!@#\$%\^&*+_=]+\z/i}
  validates :email,    length: { in: 6..50 }, format:{with:/\A^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i}
  validates :phone,    length: { in: 6..20 }#, numericality:true


end
