ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :port      => 587,
  :address   => "smtp.mandrillapp.com",
  :user_name => "taras_sypa@ukr.net",
  :password  => "84Ye2CzWZHnbudxe9agsSg"
}
