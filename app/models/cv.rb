class Cv < ActiveRecord::Base

  validates :name,:phone,:email, presence: true
  validates :name,     length: { in: 3..50 }, format: {with:/\A^[^0-9`!@#\$%\^&*+_=]+\z/i}
  validates :email,    length: { in: 6..50 }, format:{with:/\A^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i}
  validates :phone,    length: { in: 6..20 }#, numericality:true

  has_attached_file :document,
    path: ":rails_root/public/system/:class/:id/:basename.:extension",
    url:  "/system/:class/:id/:upload_title.:extension"

  validates_attachment :document, :content_type => {:content_type => %w(image/jpeg image/jpg image/png application/pdf application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document)}





end
